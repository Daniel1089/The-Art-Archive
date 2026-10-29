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
    @Environment(\.horizontalSizeClass) var sizeClass
    @AppStorage("backgroundColor") var backgroundColor: String = ""
    var body: some View {
        TabView{
            Tab("Artwork of the day", systemImage: "photo.artframe") {
                homeView()
            }
            
            Tab("Archive", systemImage: "text.below.folder"){
                NavigationStack{
                    CardStackView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .tabViewStyle(.automatic)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
    #Preview {
        ContentView()
    }
