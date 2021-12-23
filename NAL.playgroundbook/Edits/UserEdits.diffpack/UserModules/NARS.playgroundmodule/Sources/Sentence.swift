import NAL

public enum Sentence {
    case judgement(Judgement)
    case question(Question)
}

extension Sentence: CustomStringConvertible {
    public var description: String {
        switch self {
        case .judgement(let judgement):
            return "\(judgement)"
        case .question(let question):
            switch question {
            case .statement(_):
                return "\(question)?"
            default:
                return "\(question)"
            }
            
        }
    }
}
