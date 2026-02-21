import SwiftUI
import SwiftData

@main
struct BarbackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Bottle.self, ShoppingItem.self, CocktailLog.self])
    }
}
