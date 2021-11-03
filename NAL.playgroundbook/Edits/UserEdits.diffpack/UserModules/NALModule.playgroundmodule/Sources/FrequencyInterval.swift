
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
