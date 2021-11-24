
/// Basic form of Term
public struct Word: Term {
    let name: String
}

extension Word: Hashable {
    public var hashValue: Int {
        return self.name.hashValue
    }
    public static func == (left: Word, right: Word) -> Bool {
        return left.name == right.name
    }
}

extension Word: CustomStringConvertible {
    public var description: String { name }
}

extension Word: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.name = value
    }
}

/// Basic form of Statement
public struct InheritanceStatement: Statement {
    public var subject: Term
    public var copula: Copula = .inheritance
    public var predicate: Term
}

extension InheritanceStatement: CustomStringConvertible {
    public var description: String {
        String(describing: subject) + " " + copula.rawValue + " " + String(describing: predicate)
    }
}

