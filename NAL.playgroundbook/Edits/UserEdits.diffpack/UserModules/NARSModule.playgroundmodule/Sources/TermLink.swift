import NALModule

public struct TermLink: Item {
    public var identifier: String { term.description }
    public var priority: Double = 0.9
    
    public let term: Term
    
    public init(_ term: Term, _ priority: Double) {
        self.term = term
        self.priority = priority
    }
}

extension TermLink: CustomStringConvertible {
    public var description: String {
        identifier + " \(priority)"
    }
}