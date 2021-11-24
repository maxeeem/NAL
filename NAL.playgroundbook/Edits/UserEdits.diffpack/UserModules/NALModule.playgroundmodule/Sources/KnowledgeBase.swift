
public class KnowledgeBase {
    public static let instance = KnowledgeBase()
    public var knowledge: Set<String> = []
    
    public var knowledgeArray: [Statement] {
        knowledge.map({ process($0) })
    }
    
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
        
        knowledge.insert(String(describing: statement))
        
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
        if statement is InheritanceStatement {
            
            if statement.subject as? Word == "?" {
                answer(.left(statement.copula, statement.predicate))
                
            } else if statement.predicate as? Word == "?" {
                answer(.right(statement.subject, statement.copula))
                
            } else {
                let inheritanceStatements = knowledgeArray.filter({ $0 is InheritanceStatement })
                
                let matchingSubject = Set(inheritanceStatements.filter({ $0.subject.equals(statement.predicate) }).map({ String(describing: $0) }))
                let matchingPredicate = Set(inheritanceStatements.filter({ $0.predicate.equals(statement.subject) }).map({ String(describing: $0) }))
                let matches = matchingSubject.union(matchingPredicate)
                
                for match in matches.map({process($0) as! InheritanceStatement}) {
                    // apply deduction rule
                    let newStatement = deduction(premise1: match, premise2: statement as! InheritanceStatement)
                    print("++", newStatement)
                    insert(newStatement, inference: true) // insert derived knowledge
                }
            }
        }
    }
}

extension KnowledgeBase {
    public var vocabulary: Set<String> {
        var vocab: Set<String> = []
        for statement in knowledgeArray {
            vocab.insert(statement.subject)
            vocab.insert(statement.predicate)
        }
        return vocab
    }
}

extension KnowledgeBase {
    public func intension(_ term: String) -> Set<String> {
        intension(Word(stringLiteral: term))
    }
    
    public func intension(_ term: Term) -> Set<String> {
        if !vocabulary.contains(term) {
            return [] // not a known term
        }
        var int: Set<String> = [String(describing: term)]
        for statement in knowledgeArray {
            if statement.subject.equals(term) {
                int.insert(statement.predicate)
            }
        }
        return int
    }
    
    public func `extension`(_ term: String) -> Set<String> {
        `extension`(Word(stringLiteral: term))
    }
    
    public func `extension`(_ term: Term) -> Set<String> {
        if !vocabulary.contains(term) {
            return [] // not a known term
        }
        var ext: Set<String> = [String(describing: term)]
        for statement in knowledgeArray {
            if statement.predicate.equals(term) {
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
            var answers = `extension`(term).subtracting(Set(arrayLiteral: String(describing: term))).map({ Word(description: $0) })
            print("~", answers)
            for answer in answers {
                let newStatement = InheritanceStatement(subject: answer, predicate: term)
                //print(eval(newStatement))
            }
        case .right(let term, let copula):
            print("\n$", term, "is a special case of what?")
            var answers = intension(term).subtracting(Set(arrayLiteral: String(describing: term))).map({ Word(description: $0) })
            print("~", answers)
            for answer in answers {
                let newStatement = InheritanceStatement(subject: term, predicate: answer)
                //print(eval(newStatement))
            }
        }
    }
}


extension Set where Element == String {
    mutating func insert(_ term: Term) {
        self.insert(String(describing: term))
    }
    mutating func insert(_ statement: Statement) {
        self.insert(String(describing: statement))
    }
    func contains(_ term: Term) -> Bool {
        self.contains(String(describing: term))
    }
    func contains(_ statement: Statement) -> Bool {
        self.contains(String(describing: statement))
    }
}
