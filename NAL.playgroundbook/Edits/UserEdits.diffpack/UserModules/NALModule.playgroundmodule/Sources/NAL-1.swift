
public enum Sentence {
    case judgement(Judgement)
    case question(Question)
}

public struct Judgement {
    let statement: Statement
    let truthValue: TruthValue
}

public enum Question {
    case statement(Statement)
    case left(Copula, Term)
    case right(Term, Copula)
}

public struct Statement: Hashable {
    let subject: Term
    let copula: Copula
    let predicate: Term
}

public enum Copula: String {
    case inheritance = "-->"
}

public enum Term: Hashable {
    case word(String)
}

