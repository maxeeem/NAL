
public enum Copula: String {
    case inheritance = "->" 
    case similarity  = "<–>"
    case implication = "=>"
    case equivalence = "<=>"
    case instance = "•–>"  
    case property = "–>•"
    case instanceProperty = "•>•"
}

public extension Copula {
    func makeStatement(_ subject: Term, _ predicate: Term) -> Statement {
        Statement(subject: subject, copula: self, predicate: predicate)
    }
}

precedencegroup Copula { // priority
    higherThan: ComparisonPrecedence 
}

infix operator --> : Copula
public func -->(_ subject: Term, predicate: Term) -> Statement {
    Copula.inheritance.makeStatement(subject, predicate)
}
public func -->(_ subject: String, predicate: Term) -> Statement {
    Term.word(subject) --> predicate
}
public func -->(_ subject: Term, predicate: String) -> Statement {
    subject --> Term.word(predicate)
}
public func -->(_ subject: String, predicate: String) -> Statement {
    Term.word(subject) --> Term.word(predicate)
}
