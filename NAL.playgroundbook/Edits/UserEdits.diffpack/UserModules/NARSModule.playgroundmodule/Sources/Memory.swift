import NALModule

extension Bag where I == Concept {
    public func derive(_ judgement: Judgement) -> [Judgement] {
        var derivedJudgements = [Judgement]()
        
        let subject = judgement.statement.subject
        let subjectConcept = get(subject.description) ?? Concept(term: subject)
        derivedJudgements += subjectConcept.accept(judgement)
        put(subjectConcept)
        
        let predicate = judgement.statement.predicate
        let predicateConcept = get(predicate.description) ?? Concept(term: predicate)
        derivedJudgements += predicateConcept.accept(judgement, subject: false)
        put(predicateConcept)
        
        return derivedJudgements
    }
    
    public func derive(_ statement: Statement) -> [Judgement] {
        var derivedJudgements: [Judgement] = []
        
        let subject = statement.subject
        let predicate = statement.predicate
        
        let subjectConcept = get(subject.description) ?? Concept(term: subject)
        derivedJudgements += subjectConcept.answer(Question(statement))
        put(subjectConcept)
        
        let predicateConcept = get(predicate.description) ?? Concept(term: predicate)
        derivedJudgements += predicateConcept.answer(Question(statement))
        put(predicateConcept)
        
        return derivedJudgements
    }
}
