
/// Basic form of Term
public struct Word: Term {
    public let description: String
}

extension Word: Hashable {
    public var hashValue: Int {
        return self.description.hashValue
    }
    public static func == (left: Word, right: Word) -> Bool {
        return left.description == right.description
    }
}

extension Word: CustomStringConvertible, ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.description = value
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

