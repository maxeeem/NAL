


/// https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#//apple_ref/swift/grammar/typealias-declaration

/// Swift Tuple is a basic primitive
typealias Triple = (Bool?, Bool?, Bool?)
typealias Quad = (Bool?, Bool?, Bool?, Bool?)
//typealias Six = (Bool?, Bool?, Bool?, Bool?, Bool?, Bool?)

/// Statement is a fundamental type
public typealias Rule = (Statement, Statement, Statement, TruthFunction)
public typealias TruthFunction = (TruthValue, TruthValue) -> TruthValue

public typealias Apply = (_ judgements: (Judgement, Judgement)) -> Judgement? // reduce operation

public typealias Terms = (Term, Term, Term, Term)
public typealias ab = (a, a, a, a)
/*
/// https://stackoverflow.com/a/27084702
struct Parser<A> {
    let f: (String) -> [(A, String)]
}

func parse<A>(stringToParse: String, parser: Parser) 
let parser = Parser<Term> { string in return [string, tail(string)] }
 */
func +(_ a: (Term, Term), b: (Term, Term)) -> Terms {
    (a.0, a.1, b.0, b.1)
}

func firstIndex(of t: Term, in q: Terms) -> Int? {
    (q.0 == t ? 0 :
    (q.1 == t ? 1 : 
    (q.2 == t ? 2 : 
    (q.3 == t ? 3 : nil))))
}

func term(at i: Int, in q: Terms) -> Term? {
    (i == 0 ? q.0 : 
    (i == 1 ? q.1 : 
    (i == 2 ? q.2 :
    (i == 3 ? q.3 : nil))))
}

func set(_ q: inout Quad, _ i: Int, _ value: Bool?) {
    (i == 0 ? q.0 = value :
    (i == 1 ? q.1 = value :
    (i == 2 ? q.2 = value :
    (i == 3 ? q.3 = value : () ))))
}

func countTruths(in q: Quad) -> Int {
    var i = 0
    let x = true
    if q.0 == x { i += 1 }
    if q.1 == x { i += 1 }
    if q.2 == x { i += 1 }
    if q.3 == x { i += 1 }
    return i
}


let rule_generator: (_ rule: Rule) -> Apply = { (arg) -> ((Judgement, Judgement)) -> Judgement? in
    let (p1, p2, c, tf) = arg
    let commonTerms = identifyCommonTerms((p1, p2))
    // TODO: validate there is at least two true
    //       validate that not all are true
    //       validate copulas
    //       create statements from copula
    return { (arg) in
        let (j1, j2) = arg
        let t1 = j1.statement // test
        let t2 = j2.statement // test
        let s1 = Statement(t1.subject, p1.copula, t1.predicate)
        let s2 = Statement(
            commonTerms.2 == true ? commonTerms.0 == true ? 
            t1.subject : t1.predicate : t2.subject
        , p2.copula, 
            commonTerms.3 == true ? commonTerms.0 == true ? 
            t1.subject : t1.predicate : t2.predicate
        )
        if s1 == t1, s2 == t2 {
            // conclusion
            var terms = p1.terms + p2.terms
            let subject = firstIndex(of: c.subject, in: terms)!
            let predicate = firstIndex(of: c.predicate, in: terms)!
            terms = t1.terms + t2.terms
            let statement = Statement(term(at: subject, in: terms)!, c.copula, term(at: predicate, in: terms)!)
            let truthValue = tf(j1.truthValue, j2.truthValue)
            return Judgement(statement, truthValue)
        }
        return nil
    }
}

extension Judgement {
    var subject: Term { statement.subject }
    var copula: Copula { statement.copula }
    var predicate: Term { statement.predicate }
    var terms: (Term, Term) { statement.terms }
}


var identifyCommonTerms: ((Statement, Statement)) -> Quad = { (arg) in
    let t1 = arg.0.terms
    let t2 = arg.1.terms
    let res = t1 + t2
    var out = Quad(nil, nil, nil, nil)
    var tmp = Array<Term>()
    Array(0..<3+1)
        .compactMap { i in 
            let t = term(at: i, in: res) 
            return t == nil ? nil : (i, t!)
        }
        .forEach { (arg: (Int, Term)) in
            let (i, t) = arg
            if i == 0 { 
                tmp.append(t)
                set(&out, i, false)
            }
            if i == 1 && !helper(i, t) {
                tmp.append(t)
            }
            if i == 2 && !helper(i, t) {
                tmp.append(t)
                set(&out, i, nil)
            }
            if i == 3 { helper(i, t) }
        }
        func helper(_ i: Int, _ t: Term) -> Bool {
            if tmp.contains(t) {
                if let idx = firstIndex(of: t, in: res) {
                    set(&out, idx, true)
                }
                set(&out, i, true)
                return true
            }
            return false
        }
        /*
        .forEach { (arg: (Int, Term)) in
            let (i, t) = arg
            let seen = helper(i, t)
            tmp.append(t)
            set(&out, i, false)
            if !seen {
                tmp.append(t)
                set(&out, i, nil)
            }
    }
    func helper(_ i: Int, _ t: Term) -> Bool {
        if !tmp.contains(t) { return false }
        let idx = firstIndex(of: t, in: res) 
        if idx != nil { set(&out, idx!, true) }
        set(&out, i, true)
        return true
    }
 */
    return out
}
