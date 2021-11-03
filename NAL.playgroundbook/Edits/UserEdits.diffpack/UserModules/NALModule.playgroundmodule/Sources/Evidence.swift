
struct Evidence {
    let positive: Double
    let total: Double
    
    init(_ positive: Int, _ total: Int) {
        self.positive = Double(positive)
        self.total = Double(total)
    }
}

extension Evidence {
    var negative: Double {
        total - positive
    }
    var frequency: Double {
        positive / total
    }
    var confidence: Double {
        total / (total + evidentialHorizon)
    }
    var lowerFrequency: Double {
        positive / (total + evidentialHorizon)
    }
    var upperFrequency: Double {
        (positive + evidentialHorizon) / (total + evidentialHorizon)
    }
}

extension Evidence {
    var truthValue: TruthValue {
        TruthValue(frequency, confidence)
    }
}

extension Evidence {
    init<S: Statement>(_ statement: S, knowledgeBase kb: KnowledgeBase) {
        let extS = kb.extension(statement.subject)
        let extP = kb.extension(statement.predicate)
        let intS = kb.intension(statement.subject)
        let intP = kb.intension(statement.predicate)
        
        let positive = extS.intersection(extP).count + intP.intersection(intS).count
        let total = extS.count + intP.count
        
        self.init(positive, total)
        print("evidence:", self)
    }
}

extension Evidence: CustomStringConvertible {
    var description: String {
        "(\(positive), \(total))"
    }
}
