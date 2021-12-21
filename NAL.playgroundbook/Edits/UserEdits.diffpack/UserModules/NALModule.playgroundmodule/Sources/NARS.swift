
public final class NARS {
    public let memory = Bag<Concept>()
    
    public init() {
        
    }
    
    public func process(_ input: Sentence...) {
        input.forEach { s in process(s, userInitiated: true) }
    }
    
    func process(_ input: Sentence, recurse: Bool = true, userInitiated: Bool = true) {
        print(">", recurse && userInitiated ? "" : " -", input)
        switch input {
        case .judgement(let judgement): // bird --> animal <1, 0.9>
            let subject = judgement.statement.subject // bird
            let predicate = judgement.statement.predicate // animal
            
            var derivedJudgements: [Judgement] = []
            
            let subjectConcept = memory.get(subject.description) ?? Concept(term: subject)
            subjectConcept.accept(judgement)
                .forEach { j in derivedJudgements.append(j) }
            memory.put(subjectConcept)
            
            let predicateConcept = memory.get(predicate.description) ?? Concept(term: predicate)
            predicateConcept.accept(judgement, subject: false)
                .forEach { j in derivedJudgements.append(j) }
            memory.put(predicateConcept)
            
            if recurse { // TODO: add levels
                //print(">>>>+")
                //print(derivedJudgements)
                //print("----")
                derivedJudgements.forEach { j in process(.judgement(j), recurse: false) }
            }
            //let overallConcept = memory.get(judgement.statement.description) ?? Concept(term: judgement.statement)
            
        case .question(let question):
            switch question {
            case .statement(let statement):
                let subject = statement.subject // robin
                let predicate = statement.predicate // animal
                
                var derivedJudgements: [Judgement] = []
                
                let subjectConcept = memory.get(subject.description) ?? Concept(term: subject)
                subjectConcept.answer(question)
                    .forEach { j in derivedJudgements.append(j) }
                memory.put(subjectConcept)
                
                let predicateConcept = memory.get(predicate.description) ?? Concept(term: predicate)
                predicateConcept.answer(question)
                    .forEach { j in derivedJudgements.append(j) }
                memory.put(predicateConcept)
                
                if derivedJudgements.first?.statement == statement {
                    print("A:", derivedJudgements.first!)
                } else if recurse {
                    derivedJudgements.forEach { j in process(.judgement(j), recurse: true, userInitiated: false) }
                    // re-process question
                    process(.question(question), recurse: false)
                }
                
            case .general(let term, let copula):
                print(question)
            case .special(let copula, let term):
                print(question )
            }
        }
    }
}
