
extension Term where Self: Equatable {
    public func equals(_ other: Term) -> Bool {
        if other is Self {
            return (other as! Self) == self
        }
        return false
    }
}
