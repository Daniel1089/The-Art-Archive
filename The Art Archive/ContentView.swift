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
    @State private var searchText: String = ""
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house"){
               homeView()
            }
            Tab.init("Archive", systemImage: "person.crop.artframe"){
                CardStackView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    ContentView()
}
