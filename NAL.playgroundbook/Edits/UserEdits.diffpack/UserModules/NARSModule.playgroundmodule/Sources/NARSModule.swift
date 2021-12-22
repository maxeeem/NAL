import NALModule

public final class NARS {
    public let memory = Bag<Concept>()
    
    public init() {
        
    }
    
    public func process(_ input: Sentence...) {
        input.forEach { s in process(s, userInitiated: true) }
    }
    
    func process(_ input: Sentence, recurse: Bool = true, userInitiated: Bool = false) {
        print(userInitiated ? "•" : ".", recurse && userInitiated ? "" : " ⏱", input)
        switch input {
        case .judgement(let judgement): // bird --> animal <1, 0.9>
            let derivedJudgements = memory.derive(judgement)
            if recurse { // TODO: add levels
                derivedJudgements.forEach { j in process(.judgement(j), recurse: false) }
            }
        //let overallConcept = memory.get(judgement.statement.description) ?? Concept(term: judgement.statement)
        
        case .question(let question):
            switch question {
            case .statement(let statement):
                let derivedJudgements = memory.derive(statement)
                
                if derivedJudgements.first?.statement == statement {
                    print(".  💡", derivedJudgements.first!)
                } else if recurse {
                    derivedJudgements.forEach { j in process(.judgement(j), recurse: true, userInitiated: false) }
                    // re-process question
                    process(.question(question), recurse: false)
                }
                
            case .general(let term, let copula):
                guard let concept = memory.get(term.description) else {
                    print("\tI don't know 🤷‍♂️")
                    return
                }
                defer {
                    memory.put(concept) // put back
                }
                let winner = concept.answer(question).first
                print(".  💡", winner ?? "🤷‍♂️")
                
            case .special(let copula, let term):
                guard let concept = memory.get(term.description) else {
                    print("\tI don't know 🤷‍♂️")
                    return
                }
                defer {
                    memory.put(concept) // put back
                }
                let winner = concept.answer(question).first
                print(".  💡", winner ?? "🤷‍♂️")
            }
        }
    }
}

