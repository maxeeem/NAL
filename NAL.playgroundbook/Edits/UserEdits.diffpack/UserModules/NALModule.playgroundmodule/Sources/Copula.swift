
public extension Copula {
    func makeStatement(_ subject: Term, _ predicate: Term) -> some Statement {
        switch self {
        case .inheritance:
            return InheritanceStatement(subject: subject, predicate: predicate)
        }
    }
}
