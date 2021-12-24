import NAL

public func debugPrint(_ item: Any, _ separator: String = "-------") {
    print("\n"+separator+"\(type(of: item))"+separator+"\n")
    print("\(item)"+separator+"\n")
}


extension Question {
    public init(_ f: @autoclosure () -> Statement) {
        let s = f()
        if case .word(let term) = s.predicate, term.description == "?" {
            self = .general(s.subject, s.copula)
        } else if case .word(let term) = s.subject, term.description == "?" {
            self = .special(s.copula, s.predicate)
        } else {
            self = .statement(s)
        }
    }
    public var variableTerm: Term! {
        switch self {
        case .statement(let s):
            return nil
        case .special(_, let term):
            fallthrough
        case .general(let term, _): 
            return term
        }
    }
}

extension Sentence {
    public init(_ q: Question) { 
        self = .question(q) 
    }
    public init(_ j: Judgement) { 
        self = .judgement(j) 
    }
}

extension TermLink {
    public init(_ term: Term, _ priority: Double) {
        self.term = term
        self.priority = priority
    }
}

extension Belief {
    public init(_ judgement: Judgement, _ priority: Double) {
        self.judgement = judgement
        self.priority = priority
    }
}

// convenience initializer for Belief
public func +(_ j: Judgement, p: Double) -> Belief {
    Belief(j, p)
}


infix operator -*
public func -*(_ s: Statement, _ tv: (Double, Double)) -> Sentence {
    Sentence(s -* (tv.0, tv.1))
}
public func -*(_ s: Statement, _ tv: (Double, Double)) -> Judgement {
    Judgement(s, TruthValue(tv.0, tv.1))
}

postfix operator -*
extension Statement {
    public static postfix func -*(_ s: Statement) -> Sentence {
        s -* (1, 0.9)
    }
}

postfix operator -?
extension Statement {
    public static postfix func -?(_ s: Statement) -> Question { Question(s) }
    public static postfix func -?(_ s: Statement) -> Sentence { Sentence(s-?) }
}


//postfix operator -!
//extension Statement {
//    public static postfix func -!(_ s: Statement) -> Sentence {
//        Sentence.question(Question(s)) // TODO: goal
//    }
//}

// MARK: CustomStringConvertible

extension Concept: CustomStringConvertible {
    public var description: String {
        "\(term)".uppercased() + "\n.  \(termLinks)" + ".  \(beliefs)"
    }
}

extension TermLink: CustomStringConvertible {
    public var description: String {
        identifier + " \(priority)"
    }
}

extension Belief: CustomStringConvertible {
    public var description: String {
        "\(judgement)"
    }
}


// military uses made up language to teach their staff
// use it to teach nars

// pseudo code for Narsese -> Swift compiler
// transform narsese Sentence into a valid Swift string
// terms become variables: `car` -> `let car = Term.word("car")`
extension Term {
    public var swift: String {
        var id = ""
        switch self {
        case .word:
            id = ".word"
        case .compound:
            id = ".compound"
        }
        return "`let \(description) = \(type(of: self))\(id)(\"\(description)\")"
    }
    public var compoundStatement: Statement? {
        switch self {
        case .word: return nil
        case .compound(let connector, let terms):
            if terms.count == 2, let copula = Copula(rawValue: connector.description) {
                return copula.makeStatement(terms[0], terms[1])
            } else {
                return nil
            }
        }
    }
}

import Foundation
extension Term {
    public init?(s: String) {
        let words = s.components(separatedBy: " ")
        if words.count == 3, let copula = Copula(rawValue: words[1]), let t1 = Term(s: words[0]), let t2 = Term(s: words[2]) {
            self = .compound(copula.term, [t1, t2])
        } else if words.count > 1, let connector = Connector(rawValue: words[0]) {
            let terms = words.dropFirst().compactMap(Term.init(s:))
            if !terms.isEmpty {
                self = .compound(connector.term, terms)
            } else {
                return nil
            }
        } else if words.count == 1, Copula(rawValue: words[0]) == nil {
            self = .word(words[0])
        } else {
            return nil
        }
    }
    var copula: Copula? { Copula(rawValue: description) }
}
extension Copula {
    var term: Term { Term.word(rawValue) }
}
extension Connector {
    var term: Term! { Term.word(rawValue) }
}
