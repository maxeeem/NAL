



/// Swift Tuple is a basic primitive
typealias Triple = (Bool?, Bool?, Bool?)
typealias Quad = (Bool?, Bool?, Bool?, Bool?)
typealias Six = (Bool?, Bool?, Bool?, Bool?, Bool?, Bool?)

/// Statement is a fundamental type
public typealias Dual = (Statement, Statement)
public typealias Rule = (Statement, Statement, Statement)

public typealias Apply = (_ rule: Rule) -> (_ statements: Dual) -> Result // reduce operation
public typealias Result = (conclusion: Statement, (Int, Int))?

public typealias Terms = (Term, Term, Term, Term)

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


let rule_generator: Apply = { (arg) -> (Dual) -> Result in
    let (p1, p2, c) = arg
    let commonTerms = identifyCommonTerms((p1, p2))
    // TODO: validate there is at least two true
    //       validate that not all are true
    //       validate copulas
    //       create statements from copula
    return { (arg) in
        let (t1, t2) = arg
        let s1 = t1.subject --> t1.predicate
        let s2 = (commonTerms.2 == true ? (commonTerms.0 == true ? t1.subject : t1.predicate) : t2.subject)
            -->  (commonTerms.3 == true ? (commonTerms.0 == true ? t1.subject : t1.predicate) : t2.predicate)
        if s1 == t1, s2 == t2 {
            // conclusion
            var terms = p1.terms + p2.terms
            let subject = firstIndex(of: c.subject, in: terms)!
            let predicate = firstIndex(of: c.predicate, in: terms)!
            terms = t1.terms + t2.terms
            let statement = c.copula.makeStatement(term(at: subject, in: terms)!, term(at: predicate, in: terms)!)
            let tuple = (statement, (subject, predicate)) 
            return tuple
        }
        return nil
    }
}



var identifyCommonTerms: (Dual) -> Quad = { (arg) in
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
    return out
}
