
extension Statement {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.subject == rhs.subject && lhs.predicate == rhs.predicate
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(subject)
        hasher.combine(predicate)
    }
    
    public var description: String {
        String(describing: subject) + " --> " + String(describing: predicate)
        //String(describing: subject) + " is a special case of " + String(describing: predicate)
        //String(describing: predicate) + " is a general case of " + String(describing: subject)
    }
}


public struct AnyStatement: Statement {
    public typealias S = AnyTerm
    public typealias P = AnyTerm
    
    public var subject: S
    public var copula: Copula<S, P, Self>
    public var predicate: P
    
    public var statementType: String
    
    public init<A: Statement>(_ statement: A) {
        subject = AnyTerm(statement.subject)
        copula = { s, p in
            let subject = A.S.init(stringLiteral: s.description as! A.S.StringLiteralType)
            let predicate = A.P.init(stringLiteral: p.description as! A.P.StringLiteralType)
            return AnyStatement(statement.copula(subject, predicate))
        } 
        predicate = AnyTerm(statement.predicate)
        statementType = String(describing: type(of: statement))
    }
}
