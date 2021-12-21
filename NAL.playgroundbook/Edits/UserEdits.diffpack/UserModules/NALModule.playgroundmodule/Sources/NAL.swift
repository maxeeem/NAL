
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
    case special(Copula, Term)
    case general(Term, Copula)
}

public struct Statement: Hashable {
    let subject: Term
    let copula: Copula
    let predicate: Term
}

public enum Copula: String {
    case inheritance = "–>" 
    case similarity = "<–>"
    case implication = "=>"
    case equivalence = "<=>"
    
//      case instance = "•–>"  
//      case property = "–>•"
//      case instanceProperty = "•>•"
}

public enum Connector: String {
    case a = "ø"
}
//  infix operator |=>
//  prefix operator •

public indirect enum Term: Hashable {
    case word(String)
//      case instance([Term])
//      case property([Term])
    
    case compound(Term, [Term])
}



