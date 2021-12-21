
public extension Copula {
    func makeStatement(_ subject: Term, _ predicate: Term) -> Statement {
        Statement(subject: subject, copula: self, predicate: predicate)
    }
}

precedencegroup StatementComposition { higherThan: SentenceComposition }
infix operator --> : StatementComposition

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

//postfix operator -!
//extension Statement {
//    public static postfix func -!(_ s: Statement) -> Sentence {
//        Sentence.question(Question(s)) // TODO: goal
//    }
//}
