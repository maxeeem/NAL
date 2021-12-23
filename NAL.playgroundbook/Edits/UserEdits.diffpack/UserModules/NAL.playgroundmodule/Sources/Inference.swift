
/// Extended Boolean operators
/// bounded by the range from 0 to 1
public func not(_ x: Double) -> Double {
    1 - x
}
public func and(_ xs: Double...) -> Double {
    xs.reduce(1, { $0 * $1 })
}
public func or(_ xs: Double...) -> Double {
    1 - xs.reduce(1, { $0 * (1 - $1)})
}

/// NAL-1
public func revision(j1: Judgement, j2: Judgement) -> Judgement {
    let f1 = j1.truthValue.frequency
    let c1 = j1.truthValue.confidence
    let f2 = j2.truthValue.frequency
    let c2 = j2.truthValue.confidence
    let f = ((f1 * c1) * (1 - c2) + (f2 * c2) * (1 - c1)) / (c1 * (1 - c2) + c2 * (1 - c1))
    let c = (c1 * (1 - c2) + c2 * (1 - c1)) / (c1 * (1 - c2) + c2 * (1 - c1) + (1 - c1) * (1 - c2))
    return Judgement(j1.statement, TruthValue(f, c))
}

public func choice(j1: Judgement, j2: Judgement) -> Judgement {
    if j1.statement == j2.statement {
        return (j1.truthValue.confidence > j2.truthValue.confidence) ? j1 : j2
    } else {
        return (j1.truthValue.expectation > j2.truthValue.expectation) ? j1 : j2
    }
}

public func conversion(j1: Judgement) -> Judgement? {
    if j1.statement.copula != .inheritance {
        return nil // N/A
    }
    let truthValue = TruthValue.conversion(j1.truthValue)
    let statement = (j1.statement.predicate --> j1.statement.subject)
    return Judgement(statement, truthValue)
}

// MARK: Data-driven rules

public func deduction(j1: Judgement, j2: Judgement) -> Judgement? {
    guard [ // assumptions
        j1.statement.copula == .inheritance,
        j2.statement.copula == .inheritance,
        j1.statement.subject == j2.statement.predicate
    ].allValid else {
        return nil // N/A
    }
    let truthValue = TruthValue.deduction(j1.truthValue, j2.truthValue)
    let statement = (j2.statement.subject --> j1.statement.predicate)
    return Judgement(statement, truthValue)
}

public func induction(j1: Judgement, j2: Judgement) -> Judgement? {
    guard [ //assumptions
            j1.statement.copula == .inheritance,
            j2.statement.copula == .inheritance,
            j1.statement.subject == j2.statement.subject
    ].allValid else {
        return nil // N/A
    }
    let truthValue = TruthValue.induction(j1.truthValue, j2.truthValue)
    let statement = (j2.statement.predicate --> j1.statement.predicate)
    return Judgement(statement, truthValue)
}

public func abduction(j1: Judgement, j2: Judgement) -> Judgement? {
    guard [ // assumptions
            j1.statement.copula == .inheritance,
            j2.statement.copula == .inheritance,
            j1.statement.predicate == j2.statement.predicate
    ].allValid else {
        return nil // N/A
    }
    let truthValue = TruthValue.abduction(j1.truthValue, j2.truthValue)
    let statement = (j2.statement.subject --> j1.statement.subject)
    return Judgement(statement, truthValue)
}

public func exemplification(j1: Judgement, j2: Judgement) -> Judgement? {
    guard [ // assumptions
            j1.statement.copula == .inheritance,
            j2.statement.copula == .inheritance,
            j1.statement.predicate == j2.statement.subject
    ].allValid else {
        return nil // N/A
    }
    let truthValue = TruthValue.exemplification(j1.truthValue, j2.truthValue)
    let statement = (j2.statement.predicate --> j1.statement.subject)
    return Judgement(statement, truthValue)
}
