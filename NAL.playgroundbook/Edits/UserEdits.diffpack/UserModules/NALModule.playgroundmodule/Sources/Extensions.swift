

extension Statement {
    public init(_ subject: Term, _ copula: Copula, _ predicate: Term) {
        self.subject = subject
        self.copula = copula
        self.predicate = predicate
    }
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

extension Judgement {
    public init(_ statement: Statement, _ truthValue: TruthValue) {
        self.statement = statement
        self.truthValue = truthValue
    }
}

extension Question {
    public init(_ f: @autoclosure () -> Statement) {
        self = .statement(f())
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

