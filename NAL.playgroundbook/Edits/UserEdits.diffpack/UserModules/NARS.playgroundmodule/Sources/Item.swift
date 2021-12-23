import NAL

public protocol Item {
    var identifier: String { get }
    var priority: Double { get set }
}

public struct TermLink: Item {
    public var identifier: String { term.description }
    public var priority: Double = 0.9
    public let term: Term
}

public struct Belief: Item {
    public var identifier: String { judgement.statement.description }
    public var priority: Double = 0.9
    public let judgement: Judgement
}

