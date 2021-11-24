import Foundation 

public func process(_ input: String) -> Statement {
    let words = input.components(separatedBy: " ")
    let subject = Term.word(words[0])
    let predicate = Term.word(words[2])
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
    
    if isTransitive(statement, knowledge: kb.knowledge) {
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
    statement.subject == statement.predicate
}

func isTransitive(_ statement: Statement, knowledge: Set<Statement>) -> Bool {
    let matchingSubject = Set(knowledge.filter({ $0.subject == statement.subject }).map({ $0.predicate }))
    let matchingPredicate = Set(knowledge.filter({ $0.predicate == statement.predicate }).map({ $0.subject }))
    let hasCommonTerm = !matchingSubject.isDisjoint(with: matchingPredicate)
    return hasCommonTerm
}


