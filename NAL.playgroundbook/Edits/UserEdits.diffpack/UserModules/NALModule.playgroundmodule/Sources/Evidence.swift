
struct Evidence {
    let positive: Double
    let total: Double
    
    init(_ positive: Double, _ total: Double) {
        self.positive = positive
        self.total = total
    }
    
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

extension Evidence: CustomStringConvertible {
    var description: String {
        "(\(positive), \(total))"
    }
}


// MARK: Frequency interval

struct FrequencyInterval {
    let lower: Double
    let upper: Double
    
    init(_ lower: Double, _ upper: Double) {
        self.lower = lower
        self.upper = upper
    }
}

extension FrequencyInterval {
    var ignorance: Double {
        upper - lower
    }
    var positiveEvidence: Double {
        evidentialHorizon * lower / ignorance
    }
    var totalEvidence: Double {
        evidentialHorizon * (1 - ignorance) / ignorance
    }
    var frequency: Double {
        lower / (1 - ignorance)
    }
    var confidence: Double {
        1 - ignorance
    }
}
