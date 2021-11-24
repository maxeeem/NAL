

public func deduction(premise1: Statement, premise2: Statement) -> Statement {
    assert(premise1.copula == .inheritance)
    assert(premise2.copula == .inheritance)
    return Copula.inheritance.makeStatement(premise2.subject, premise1.predicate)
}
