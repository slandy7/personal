import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Home"
        case bar = "My Bar"
        case cocktails = "Cocktails"
        case shopping = "Shopping"
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            BarView()
                .tabItem {
                    Label("My Bar", systemImage: "wineglass.fill")
                }
                .tag(Tab.bar)

            CocktailListView()
                .tabItem {
                    Label("Cocktails", systemImage: "book.fill")
                }
                .tag(Tab.cocktails)

            ShoppingListView()
                .tabItem {
                    Label("Shopping", systemImage: "cart.fill")
                }
                .tag(Tab.shopping)
        }
        .tint(AppTheme.amber)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
