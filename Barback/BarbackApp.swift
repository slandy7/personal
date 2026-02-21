import SwiftUI
import SwiftData

@main
struct BarbackApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Bottle.self, ShoppingItem.self, CocktailLog.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
