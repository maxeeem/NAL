
public struct AnyTerm: Term {
    public var description: StringLiteralType
    public init<T: Term>(_ term: T) {
        self.description = term.description
    }
    public init(stringLiteral value: StringLiteralType) {
        self.description = value
    }
}
