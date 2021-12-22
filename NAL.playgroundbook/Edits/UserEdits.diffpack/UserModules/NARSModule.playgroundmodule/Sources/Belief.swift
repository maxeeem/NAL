import NALModule

public struct Belief: Item {
    public var identifier: String { judgement.statement.description }
    public var priority: Double = 0.9
    
    public let judgement: Judgement
    
    public init(_ judgement: Judgement, _ priority: Double) {
        self.judgement = judgement
        self.priority = priority
    }
}

extension Belief: CustomStringConvertible {
    public var description: String {
        "\(judgement)"
    }
}
