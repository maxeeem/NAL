
public func debugPrint(_ item: Any, _ separator: String = "-------") {
    print("\n"+separator+"\(type(of: item))"+separator+"\n")
    print("\(item)"+separator+"\n")
}
