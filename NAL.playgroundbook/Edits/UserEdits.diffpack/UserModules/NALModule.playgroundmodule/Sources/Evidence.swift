
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
