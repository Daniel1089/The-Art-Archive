import SwiftUI
import Playgrounds

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house"){
                
            }
            Tab.init("Archive", systemImage: "person.crop.artframe"){
                ArchiveView()
            }
        }
    }
}

#Preview {
    ContentView()
}
