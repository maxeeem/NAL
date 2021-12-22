
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



extension Statement {
    public init(_ subject: Term, _ copula: Copula, _ predicate: Term) {
        self.subject = subject
        self.copula = copula
        self.predicate = predicate
    }
}

extension Judgement {
    public init(_ statement: Statement, _ truthValue: TruthValue) {
        self.statement = statement
        self.truthValue = truthValue
    }
}

extension Question {
    public init(_ f: @autoclosure () -> Statement) {
        let s = f()
        if case .word(let term) = s.predicate, term.description == "?" {
            self = .general(s.subject, s.copula)
        } else if case .word(let term) = s.subject, term.description == "?" {
            self = .special(s.copula, s.predicate)
        } else {
            self = .statement(s)
        }
    }
}

extension Sentence {
    public init(_ q: Question) {
        self = .question(q)
    }
    public init(_ j: Judgement) {
        self = .judgement(j)
    }
}


extension Question {
    public var variableTerm: Term! {
        switch self {
        case .statement(let s):
            return nil
        case .special(_, let term):
            fallthrough
        case .general(let term, _): 
            return term
        }
    }
}


precedencegroup SentenceComposition { }
infix operator -* : SentenceComposition

public func -*(_ s: Statement, _ tv: (Double, Double)) -> Sentence {
    Sentence(s -* (tv.0, tv.1))
}

public func -*(_ s: Statement, _ tv: (Double, Double)) -> Judgement {
    Judgement(s, TruthValue(tv.0, tv.1))
}



postfix operator -?
extension Statement {
    public static postfix func -?(_ s: Statement) -> Sentence {
        Sentence(s-?)
    }
    public static postfix func -?(_ s: Statement) -> Question {
        Question(s)
    }
}

postfix operator -*
extension Statement {
    public static postfix func -*(_ s: Statement) -> Sentence {
        s -* (1, 0.9)
    }
}

//postfix operator -!
//extension Statement {
//    public static postfix func -!(_ s: Statement) -> Sentence {
//        Sentence.question(Question(s)) // TODO: goal
//    }
//}


/// from https://stackoverflow.com/a/34699637
extension Array where Element == Bool {
    public var allValid: Bool { !contains(false) }
}


/// from https://stackoverflow.com/a/38036978
public func rounded(_ d: Double, _ x: Int = 10000) -> Double {
    (d * Double(x)).rounded() / Double(x)
}
