
public func eval<S: Statement>(_ statement: S) -> TruthValue {
    eval(statement, knowledgeBase: KnowledgeBase.instance)
}

public func eval<S: Statement>(_ statement: S, knowledgeBase kb: KnowledgeBase) -> TruthValue {
    print("\nconsider:", statement, "?")
    
    if isTautology(statement) {
        return TruthValue(1, 1)
    }
    
    if isTransitive(statement, knowledge: kb.knowledge) {
        let ev = Evidence(statement, knowledgeBase: kb)
        kb.knowledge.insert(AnyStatement(statement))
        return ev.truthValue
    }
    
    if kb.knowledge.contains(AnyStatement(statement)) {
        let ev = Evidence(statement, knowledgeBase: kb)
        return ev.truthValue // question answering
    }
    
    return TruthValue(0, 0)
}

// Private
func isTautology<S: Statement>(_ statement: S) -> Bool {
    statement.subject == statement.predicate as? S.S
}

func isTransitive<S: Statement>(_ statement: S, knowledge: Set<AnyStatement>) -> Bool {
    let matchingSubject = Set(knowledge.filter({ $0.subject == AnyTerm(statement.subject) }).map({ $0.predicate }))
    let matchingPredicate = Set(knowledge.filter({ $0.predicate == AnyTerm(statement.predicate) }).map({ $0.subject }))
    let hasCommonTerm = !matchingSubject.isDisjoint(with: matchingPredicate)
    return hasCommonTerm
}


