

public enum Sentence<S: Statement> {
    case judgement(S)
    case question(S)
}

public protocol Judgement {
    associatedtype S: Statement
    var statement: S { get }
    var truthValue: TruthValue { get }
}

public protocol Question {
    associatedtype S: Statement
    var statement: S { get }
}

public protocol Statement: Hashable, CustomStringConvertible {
    associatedtype S: Term
    associatedtype P: Term
    var subject: S { get }
    var copula: Copula<S, P, Self> { get }
    var predicate: P { get }
}

public typealias Copula<S: Term, P: Term, M: Statement> = (S, P) -> M

public protocol Term: Hashable, CustomStringConvertible, ExpressibleByStringLiteral {
    // var description: String
}

