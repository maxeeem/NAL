

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


extension Bag where I == Concept {
    public func derive(_ judgement: Judgement) -> [Judgement] {
        var derivedJudgements = [Judgement]()
        
        let subject = judgement.statement.subject
        let predicate = judgement.statement.predicate
        
        let subjectConcept = get(subject.description) ?? Concept(term: subject)
        subjectConcept.accept(judgement)
            .forEach { j in derivedJudgements.append(j) }
        put(subjectConcept)
        
        let predicateConcept = get(predicate.description) ?? Concept(term: predicate)
        predicateConcept.accept(judgement, subject: false)
            .forEach { j in derivedJudgements.append(j) }
        put(predicateConcept)
        
        return derivedJudgements
    }
//    public func derive(_ statement: Statement) -> [Judgement] {
//        var derivedJudgements = [Judgement]()
//        
//        let subject = statement.subject // robin
//        let predicate = statement.predicate // animal
//        
//        let subjectConcept = get(subject.description) ?? Concept(term: subject)
//        subjectConcept.answer(question)
//            .forEach { j in derivedJudgements.append(j) }
//        put(subjectConcept)
//        
//        let predicateConcept = get(predicate.description) ?? Concept(term: predicate)
//        predicateConcept.answer(question)
//            .forEach { j in derivedJudgements.append(j) }
//        put(predicateConcept)
//        
//        return derivedJudgements
//    }
}
