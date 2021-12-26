import NAL

public enum Sentence {
    case judgement(Judgement)
    case question(Question)
}

public final class NARS {
    public let memory = Bag<Concept>()
    public var output: (String) -> Void
    
    public init(_ output: @escaping (String) -> Void = { print($0) }) {
        self.output = output
    }
    
    public func process(_ input: Sentence...) {
        // TODO: add buffer
        input.forEach { s in process(s, userInitiated: true) }
    }
}

// MARK: Private

extension NARS {
    private func process(_ input: Sentence, recurse: Bool = true, userInitiated: Bool = false) {
        output((userInitiated ? "•" : ".") + (recurse && userInitiated ? "" : "  ⏱") + " \(input)")
        switch input {
        case .judgement(let judgement):
            let derivedJudgements = memory.consider(judgement)
            if recurse { // TODO: add levels
                derivedJudgements.forEach { j in process(.judgement(j), recurse: false) }
            }
        case .question(let question):
            let derivedJudgements = memory.consider(question)
            if case .statement(let statement) = question {
                if let winner = derivedJudgements.first, winner.statement == statement {
                    output(".  💡 \(winner)")
                } else if recurse { // TODO: add levels
                    derivedJudgements.forEach { j in process(.judgement(j), recurse: true) }
                    // re-process question
                    process(.question(question), recurse: false)
                }
            } else if let winner = derivedJudgements.first {
                output(".  💡 \(winner)")
            } else {
                output("\tI don't know 🤷‍♂️")
            }
        }
    }
}

