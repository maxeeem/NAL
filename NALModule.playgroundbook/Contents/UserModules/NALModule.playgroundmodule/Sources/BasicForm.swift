
// Basic form of Term
public struct Word: Term {
    public var description: StringLiteralType
    public init(stringLiteral value: StringLiteralType) {
        self.description = value
    }
}

// Basic form of Statement
public struct InheritanceStatement<S: Term, P: Term>: Statement {
    public var subject: S
    public var copula: Copula<S, P, Self> = { $0 --> $1 }
    public var predicate: P
}

// Basic form of a Question
public struct BasicQuestion<S: Statement>: Question {
    public var statement: S
    public init(_ statement: S) {
        self.statement = statement
    }
}
