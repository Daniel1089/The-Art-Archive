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
    @AppStorage("backgroundColor") var backgroundColor: String = ""
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                HStack{
                    homeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .containerRelativeFrame(.horizontal)
                }
                .containerRelativeFrame(.horizontal)
                HStack{
                    CardStackView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .containerRelativeFrame(.horizontal)
                }
                .containerRelativeFrame(.horizontal)
            }
        }
        .frame(width: .infinity, height: .infinity)
             .ignoresSafeArea()
             .scrollTargetBehavior(.paging)
        }
    }

#Preview {
    ContentView()
}
