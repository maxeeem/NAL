
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


extension Sentence: CustomStringConvertible {
    public var description: String {
        switch self {
        case .judgement(let judgement):
            return "\(judgement)"
        case .question(let question):
            switch question {
            case .statement(_):
                return "\(question)?"
            default:
                return "\(question)"
            }
            
        }
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



public func debugPrint(_ item: Any, _ separator: String = "-------") {
    print("\n"+separator+"\(type(of: item))"+separator+"\n")
    print(item)
    print("\n"+separator+"\n")
}
