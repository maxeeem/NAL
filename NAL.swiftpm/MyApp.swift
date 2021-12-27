import SwiftUI
import Combine
import NARS

extension NARS: ObservableObject {}

@main
struct MyApp: App {
    let nars = NARS()
    
    var mem = CurrentValueSubject<Set<String>, Never>([])
    
    var cycle = PassthroughSubject<Void, Never>()
    
    var clock = Timer(timeInterval: 1, repeats: true) { timer in
        
    }
    
    var body: some Scene {
        
//        Memory(identifier: "").body
//        mem.sink { concepts in
//            Think()
//        }
//        
        return WindowGroup {
            ContentView()
                .environmentObject(nars)
        }
    }
}

struct Memory: App {
    var identifier: String = ""
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands { 
            ToolbarCommands()
        }
    }
}

