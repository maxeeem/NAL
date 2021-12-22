
extension Question: CustomStringConvertible {
    public var description: String {
        switch self {
        case .statement(let statement):
            return "\(statement)"
        case .general(let term, let copula):
            return "\(term) \(copula.rawValue) ?"
        case .special(let copula, let term):
            return "? \(copula.rawValue) \(term)"
        }
    }
}

extension Judgement: CustomStringConvertible {
    public var description: String {
        "\(statement)" + "\(truthValue)"
    }
}

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
        case .compound(let connector, let terms):
            return "\(connector) \(terms)"
        }
    }
}


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



extension Array where Element == Bool {
    var allValid: Bool {
        reduce(true, {$0 == $1} ) == true
    }
}
