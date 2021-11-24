

public func deduction(premise1: InheritanceStatement, premise2: InheritanceStatement) -> InheritanceStatement {
    InheritanceStatement(subject: premise2.subject, predicate: premise1.predicate)
}
