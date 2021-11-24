
extension Statement: CustomStringConvertible {
    public var description: String {
        "\(subject) " + copula.rawValue + " \(predicate)"
    }
}

extension Term: CustomStringConvertible {
    public var description: String {
        switch self {
        case .word(let word):
            return word
        }
    }
}

public func print(_ knowledge: Set<String>) {
    print("--")
    for statement in knowledge {
        print(statement)
    }
    print("--")
}

