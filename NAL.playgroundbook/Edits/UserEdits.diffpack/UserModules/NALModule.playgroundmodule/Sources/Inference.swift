
/// IL-1
public func deduction(premise1: Statement, premise2: Statement) -> Statement {
    assert(premise1.copula == .inheritance)
    assert(premise2.copula == .inheritance)
    assert(premise1.subject == premise2.predicate)
    return Copula.inheritance.makeStatement(premise2.subject, premise1.predicate)
}

/// NAL-1
public func revision(j1: Judgement, j2: Judgement) -> Judgement {
    assert(j1.statement == j2.statement)
    let f1 = j1.truthValue.frequency
    let c1 = j1.truthValue.confidence
    let f2 = j2.truthValue.frequency
    let c2 = j2.truthValue.confidence
    let frequency = ((f1 * c1) * (1 - c2) + (f2 * c2) * (1 - c1)) / (c1 * (1 - c2) + c2 * (1 - c1))
    let confidence = (c1 * (1 - c2) + c2 * (1 - c1)) / (c1 * (1 - c2) + c2 * (1 - c1) + (1 - c1) * (1 - c2))
    return Judgement(statement: j1.statement, truthValue: TruthValue(frequency, confidence))
}

public func choice(j1: Judgement, j2: Judgement) -> Judgement {
    if j1.statement == j2.statement {
        if j1.truthValue.confidence > j2.truthValue.confidence {
            return j1
        } else {
            return j2
        }
    } else {
        if j1.truthValue.expectation > j2.truthValue.expectation {
            return j1
        } else {
            return j2
        }
    }
}

public func deduction(j1: Judgement, j2: Judgement) -> Judgement {
    assert(j1.statement.copula == .inheritance)
    assert(j2.statement.copula == .inheritance)
    assert(j1.statement.subject == j2.statement.predicate)
    let truthValue = TruthValue.deduction(j1.truthValue, j2.truthValue)
    let statement = Copula.inheritance.makeStatement(j2.statement.subject, j1.statement.predicate)
    return Judgement(statement, truthValue)
}

public func induction(j1: Judgement, j2: Judgement) -> Judgement {
    assert(j1.statement.copula == .inheritance)
    assert(j2.statement.copula == .inheritance)
    assert(j1.statement.subject == j2.statement.subject)
    let truthValue = TruthValue.induction(j1.truthValue, j2.truthValue)
    let statement = Copula.inheritance.makeStatement(j2.statement.predicate, j1.statement.predicate)
    return Judgement(statement, truthValue)
}

public func abduction(j1: Judgement, j2: Judgement) -> Judgement {
    assert(j1.statement.copula == .inheritance)
    assert(j2.statement.copula == .inheritance)
    assert(j1.statement.predicate == j2.statement.predicate)
    let truthValue = TruthValue.abduction(j1.truthValue, j2.truthValue)
    let statement = Copula.inheritance.makeStatement(j2.statement.subject, j1.statement.subject)
    return Judgement(statement, truthValue)
}

public func conversion(j1: Judgement) -> Judgement {
    assert(j1.statement.copula == .inheritance)
    let truthValue = TruthValue.conversion(j1.truthValue)
    let statement = Copula.inheritance.makeStatement(j1.statement.predicate, j1.statement.subject)
    return Judgement(statement, truthValue)
}

public func exemplification(j1: Judgement, j2: Judgement) -> Judgement {
    assert(j1.statement.copula == .inheritance)
    assert(j2.statement.copula == .inheritance)
    assert(j1.statement.predicate == j2.statement.subject)
    let truthValue = TruthValue.exemplification(j1.truthValue, j2.truthValue)
    let statement = Copula.inheritance.makeStatement(j2.statement.predicate, j1.statement.subject)
    return Judgement(statement, truthValue)
}
