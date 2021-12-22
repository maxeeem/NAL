
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

precedencegroup SentenceComposition { }
infix operator -* : SentenceComposition

public func -*(_ s: Statement, _ tv: (Double, Double)) -> Sentence {
    Sentence(s -* (tv.0, tv.1))
}

public func -*(_ s: Statement, _ tv: (Double, Double)) -> Judgement {
    Judgement(s, TruthValue(tv.0, tv.1))
}


/// from https://stackoverflow.com/a/34699637
extension Array where Element == Bool {
    var allValid: Bool { !contains(false) }
}


/// from https://stackoverflow.com/a/38036978
public func rounded(_ d: Double, _ x: Int = 10000) -> Double {
    (d * Double(x)).rounded() / Double(x)
}
