
public struct TruthValue {
    let frequency: Double 
    let confidence: Double
    
    init(_ frequency: Double, _ confidence: Double) {
        self.frequency = frequency
        self.confidence = confidence
    }
}

extension TruthValue {
    var positiveEvidence: Double {
        Double(evidentialHorizon) * frequency * confidence / (1 - confidence)
    }
    var totalEvidence: Double {
        Double(evidentialHorizon) * confidence / (1 - confidence)
    }
    var lowerFrequency: Double {
        frequency * confidence
    }
    var upperFrequency: Double {
        1 - confidence * (1 - frequency)
    }
}

extension TruthValue: CustomStringConvertible {
    public var description: String {
        "(\(frequency), \(confidence))"
    }
}
