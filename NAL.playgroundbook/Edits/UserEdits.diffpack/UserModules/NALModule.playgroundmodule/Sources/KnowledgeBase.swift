
public class KnowledgeBase {
    public static let instance = KnowledgeBase()
    public var knowledge: Set<AnyStatement> = []
    
    public func insert<S: Statement>(_ statement: S, inference: Bool = false) {
        if inference == false {
            print("\n$", statement)
        }
        
        if isTautology(statement) { 
            return // no need to insert tautology
        }
        
        knowledge.insert(AnyStatement(statement))
        
        //tmp
        infer(statement)
        
        if inference == false {
            print(knowledge)
        }
    }
    
    public func infer<S: Statement>(_ statement: S) {
        if statement is InheritanceStatement<S.S, S.P> {
            if statement.subject as? Word == "?" {
                let term = statement.predicate
                print("\n$", term, "is a general case of what?")
                var answers = `extension`(term).subtracting(Set(arrayLiteral: AnyTerm(term)))
                print("~", answers)
                for answer in answers {
                    let newStatement = InheritanceStatement(subject: answer, copula: { $0 --> $1 }, predicate: term)
                    print(eval(newStatement))
                }
            } else if statement.predicate as? Word == "?" {
                let term = statement.subject
                print("\n$", term, "is a special case of what?")
                var answers = intension(term).subtracting(Set(arrayLiteral: AnyTerm(term)))
                print("~", answers)
                for answer in answers {
                    let newStatement = InheritanceStatement(subject: term, copula: { $0 --> $1 }, predicate: answer)
                    print(eval(newStatement))
                }
            } else {
                let originalStatement = AnyTerm(statement.subject) --> AnyTerm(statement.predicate)
                let inheritanceStatements = knowledge.filter({ $0.statementType.hasPrefix("InheritanceStatement") }).map {
                    InheritanceStatement(subject: $0.subject, predicate: $0.predicate)
                }
                
                let matchingSubject = Set(inheritanceStatements.filter({ $0.subject == originalStatement.predicate }))
                let matchingPredicate = Set(inheritanceStatements.filter({ $0.predicate == originalStatement.subject }))
                let matches = matchingSubject.union(matchingPredicate)
                
                for match in matches {
                    // apply deduction rule
                    let newStatement = deduction(premise1: match, premise2: originalStatement)
                    print("++", newStatement)
                    insert(newStatement, inference: true) // insert derived knowledge
                }
            }
        }
    }
}

extension KnowledgeBase {
    public var vocabulary: Set<AnyTerm> {
        var vocab: Array<AnyTerm> = []
        for statement in knowledge {
            vocab.append(statement.subject)
            vocab.append(statement.predicate)
        }
        return Set(vocab)
    }
}

extension KnowledgeBase {
    public func intension(_ term: String) -> Set<AnyTerm> {
        intension(Word(stringLiteral: term))
    }
    
    public func intension<T: Term>(_ term: T) -> Set<AnyTerm> {
        if !vocabulary.contains(AnyTerm(term)) {
            return [] // not a known term
        }
        var int: Set<AnyTerm> = [AnyTerm(term)]
        for statement in knowledge {
            if statement.subject == AnyTerm(term) {
                int.insert(statement.predicate)
            }
        }
        return int
    }
    
    public func `extension`(_ term: String) -> Set<AnyTerm> {
        `extension`(Word(stringLiteral: term))
    }
    
    public func `extension`<T: Term>(_ term: T) -> Set<AnyTerm> {
        if !vocabulary.contains(AnyTerm(term)) {
            return [] // not a known term
        }
        var ext: Set<AnyTerm> = [AnyTerm(term)]
        for statement in knowledge {
            if statement.predicate == AnyTerm(term) {
                ext.insert(statement.subject)
            }
        }
        return ext
    }
}

extension KnowledgeBase {
    
}
