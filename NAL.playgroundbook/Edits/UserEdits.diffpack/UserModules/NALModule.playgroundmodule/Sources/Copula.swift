
public extension Copula {
    func makeStatement(_ subject: Term, _ predicate: Term) -> Statement {
        Statement(subject: subject, copula: self, predicate: predicate)
    }
}
