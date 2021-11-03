
//  public func infer<S, M, P>(knowledge: inout Set<AnyStatement>) {
//      let inheritance = knowledge.filter({ $0 is InheritanceStatement })
//  }

//  protocol Deduction {
public func deduction<M, P, S>(premise1: InheritanceStatement<M, P>, premise2: InheritanceStatement<S, M>) -> InheritanceStatement<S, P> {
    premise2.subject --> premise1.predicate
}
//  }
