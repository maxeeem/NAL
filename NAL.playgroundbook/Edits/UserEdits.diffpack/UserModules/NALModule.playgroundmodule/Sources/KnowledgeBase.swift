
public class KnowledgeBase {
    public static let instance = KnowledgeBase()
    public var knowledge: Set<Statement> = []
    
    public var verboseOutput = true
    
    public func insert(_ string: String) {
        let statement = process(string)
        insert(statement)
    }
    
    public func insert(_ statement: Statement, inference: Bool = false) {
        if inference == false {
            print("\n$", statement)
        }
        
        if isTautology(statement) { 
            return // no need to insert tautology
        }
        
        knowledge.insert(statement)
        
        //tmp
        infer(statement)
        
        if inference == false && verboseOutput == true {
            print(knowledge)
        }
    }
    
    public func infer(_ string: String) {
        let statement = process(string)
        infer(statement)
    }
    
    public func infer(_ statement: Statement) {
        if statement.copula == .inheritance {
            
            if case .word(let word) = statement.subject, word == "?" {
                answer(.left(statement.copula, statement.predicate))
                
            } else if case .word(let word) = statement.predicate, word == "?" {
                answer(.right(statement.subject, statement.copula))
                
            } else {
                let inheritanceStatements = knowledge.filter({ $0.copula == .inheritance })
                
                let matchingSubject = Set(inheritanceStatements.filter({ $0.subject == statement.predicate }))
                let matchingPredicate = Set(inheritanceStatements.filter({ $0.predicate == statement.subject }))
                let matches = matchingSubject.union(matchingPredicate)
                
                for match in matches {
                    // apply deduction rule
                    let newStatement = deduction(premise1: match, premise2: statement)
                    print("++", newStatement)
                    insert(newStatement, inference: true) // insert derived knowledge
                }
            }
        }
    }
}

extension KnowledgeBase {
    public var vocabulary: Set<Term> {
        var vocab: Set<Term> = []
        for statement in knowledge {
            vocab.insert(statement.subject)
            vocab.insert(statement.predicate)
        }
        return vocab
    }
}

extension KnowledgeBase {
    public func intension(_ term: String) -> Set<Term> {
        intension(Term.word(term))
    }
    
    public func intension(_ term: Term) -> Set<Term> {
        if !vocabulary.contains(term) {
            return [] // not a known term
        }
        var int: Set<Term> = [term]
        for statement in knowledge {
            if statement.subject == term {
                int.insert(statement.predicate)
            }
        }
        return int
    }
    
    public func `extension`(_ term: String) -> Set<Term> {
        `extension`(Term.word(term))
    }
    
    public func `extension`(_ term: Term) -> Set<Term> {
        if !vocabulary.contains(term) {
            return [] // not a known term
        }
        var ext: Set<Term> = [term]
        for statement in knowledge {
            if statement.predicate == term {
                ext.insert(statement.subject)
            }
        }
        return ext
    }
}

extension KnowledgeBase {
    public func answer(_ question: Question) {
        switch question {
        case .statement(let statement):
            _ = eval(statement)
        case .left(let copula, let term):
            print("\n$", term, "is a general case of what?")
            var answers = `extension`(term).subtracting(Set(arrayLiteral: term))
            print("~", answers)
            for answer in answers {
                let newStatement = Statement(subject: answer, copula: copula, predicate: term)
                //print(eval(newStatement))
            }
        case .right(let term, let copula):
            print("\n$", term, "is a special case of what?")
            var answers = intension(term).subtracting(Set(arrayLiteral: term))
            print("~", answers)
            for answer in answers {
                let newStatement = Statement(subject: term, copula: copula, predicate: answer)
                //print(eval(newStatement))
            }
        }
    }
}

