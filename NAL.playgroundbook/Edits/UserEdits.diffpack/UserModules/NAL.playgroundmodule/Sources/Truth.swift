
public struct TruthValue {
    let frequency: Double 
    let confidence: Double
}

extension TruthValue {
    static func conversion(_ tv1: TruthValue) -> TruthValue {
        let f1 = tv1.frequency
        let c1 = tv1.confidence
        let c = f1 * c1 / (f1 * c1 + evidentialHorizon)
        return TruthValue(1, c)
    }
    static func deduction(_ tv1: TruthValue, _ tv2: TruthValue) -> TruthValue {
        let f1 = tv1.frequency
        let c1 = tv1.confidence
        let f2 = tv2.frequency
        let c2 = tv2.confidence
        let f = and(f1, f2)
        let c = and(f1, f2, c1, c2)
        return TruthValue(f, c)
    }
    static func induction(_ tv1: TruthValue, _ tv2: TruthValue) -> TruthValue {
        let f1 = tv1.frequency
        let c1 = tv1.confidence
        let f2 = tv2.frequency
        let c2 = tv2.confidence
        let positive = and(f2, c2, f1, c1) // w+
        let total = and(f2, c2, c1) // w
        let evidence = Evidence(positive, total)
        return TruthValue(evidence)
    }
    static func abduction(_ tv1: TruthValue, _ tv2: TruthValue) -> TruthValue {
        let f1 = tv1.frequency
        let c1 = tv1.confidence
        let f2 = tv2.frequency
        let c2 = tv2.confidence
        let positive = and(f1, c1, f2, c2) // w+
        let total = and(f1, c1, c2) // w
        let evidence = Evidence(positive, total)
        return TruthValue(evidence)
    }
    static func exemplification(_ tv1: TruthValue, _ tv2: TruthValue) -> TruthValue {
        let f1 = tv1.frequency
        let c1 = tv1.confidence
        let f2 = tv2.frequency
        let c2 = tv2.confidence
        let positive = and(f1, c1, f2, c2) // w+
        let total = and(f1, c1, f2, c2) // w
        let evidence = Evidence(positive, total)
        return TruthValue(evidence)
    }
}
