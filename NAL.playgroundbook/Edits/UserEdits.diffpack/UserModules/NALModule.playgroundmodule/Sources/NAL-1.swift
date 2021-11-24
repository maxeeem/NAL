
public enum Sentence {
    case judgement(Judgement)
    case question(Question)
}

public protocol Judgement {
    var statement: Statement { get }
    var truthValue: TruthValue { get }
}

public enum Question {
    case statement(Statement)
    case left(Copula, Term)
    case right(Term, Copula)
}

public protocol Statement {
    var subject: Term { get }
    var copula: Copula { get }
    var predicate: Term { get }
}

public enum Copula: String {
    case inheritance = "-->"
}

public protocol Term {
    func equals(_ other: Term) -> Bool
}

