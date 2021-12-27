import SwiftUI
import NARS

struct ContentView: View {
    @EnvironmentObject var nars: NARS
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("I'm \(nars.name) 👋")
                .modifier(Nal1(color: .blue))
            Spacer()
//            Think()
//                .modifier(Nal1(color: .gray))
        }
    }
}

typealias Concept = View

struct Think: Concept {
    var body: some View {
        Text("bird is an animal")
    }
}

struct Nal1: ViewModifier {
    let color: Color // frequency
    let rules: [()->()] = []
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.quaternary, in: Capsule())
            .foregroundColor(color)
    }
}

struct MyModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .modifier(Nal1(color: .red))
    }
}
