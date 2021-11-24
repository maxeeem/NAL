import Foundation 

public func process(_ input: String) -> Statement {
    let words = input.components(separatedBy: " ")
    let subject = Word(description: words[0])
    let predicate = Word(description: words[2])
    let copula = Copula(rawValue: words[1])!
    return copula.makeStatement(subject, predicate)
}

public func eval(_ string: String) -> TruthValue {
    let statement = process(string)
    return eval(statement)
}

public func eval(_ statement: Statement) -> TruthValue {
    eval(statement, knowledgeBase: KnowledgeBase.instance)
}

public func eval(_ statement: Statement, knowledgeBase kb: KnowledgeBase) -> TruthValue {
    print("\nconsider:", statement, "?")
    
    if isTautology(statement) {
        return TruthValue(1, 1)
    }
    
    if isTransitive(statement, knowledge: kb.knowledgeArray) {
        let ev = Evidence(statement, knowledgeBase: kb)
        kb.knowledge.insert(statement)
        return ev.truthValue
    }
    
    if kb.knowledge.contains(statement) {
        let ev = Evidence(statement, knowledgeBase: kb)
        return ev.truthValue // question answering
    }
    
    return TruthValue(0, 0)
}

// Private
func isTautology(_ statement: Statement) -> Bool {
    statement.subject.equals(statement.predicate)
}

func isTransitive(_ statement: Statement, knowledge: Array<Statement>) -> Bool {
    let matchingSubject = Set(knowledge.filter({ $0.subject.equals(statement.subject) }).map({ String(describing: $0.predicate) }))
    let matchingPredicate = Set(knowledge.filter({ $0.predicate.equals(statement.predicate) }).map({ String(describing: $0.subject) }))
    let hasCommonTerm = !matchingSubject.isDisjoint(with: matchingPredicate)
    return hasCommonTerm
}


