
infix operator --> // inheritance copula
public func --><S: Term, P: Term>(subject: S, predicate: P) -> InheritanceStatement<S, P> {
    InheritanceStatement(subject: subject, predicate: predicate)
}

public func -->(subject: String, predicate: String) -> InheritanceStatement<Word, Word> {
    Word(stringLiteral: subject) --> Word(stringLiteral: predicate)
}

public func --><S: Term>(subject: S, predicate: String) -> InheritanceStatement<S, Word> {
    subject --> Word(stringLiteral: predicate)
}

public func --><P: Term>(subject: String, predicate: P) -> InheritanceStatement<Word, P> {
    Word(stringLiteral: subject) --> predicate
}

