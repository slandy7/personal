import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddBottle = false
    @State private var selectedCocktail: Cocktail?
    @State private var navigationPath = NavigationPath()

    private var inventory: Set<String> {
        Set(bottles.filter { $0.level > 0 }.map { $0.ingredientName })
    }

    private var canMakeMatches: [CocktailMatch] {
        MatchEngine.canMake(inventory: inventory)
    }

    private var almostMatches: [CocktailMatch] {
        MatchEngine.almostCanMake(inventory: inventory)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning."
        case 12..<17: return "Good afternoon."
        case 17..<22: return "Good evening."
        default: return "Burning the midnight oil."
        }
    }

    private var subtitle: String {
        if bottles.isEmpty {
            return "Let's stock your bar."
        } else if canMakeMatches.isEmpty {
            return "Add a few more bottles to unlock cocktails."
        } else {
            return "You can make \(canMakeMatches.count) cocktail\(canMakeMatches.count == 1 ? "" : "s")."
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: - Greeting
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    // MARK: - Stats
                    HStack(spacing: 12) {
                        StatCard(
                            title: "Bottles",
                            value: "\(bottles.count)",
                            icon: "wineglass.fill",
                            color: .orange
                        )
                        StatCard(
                            title: "Can Make",
                            value: "\(canMakeMatches.count)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        StatCard(
                            title: "Recipes",
                            value: "\(CocktailDatabase.count)",
                            icon: "book.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Tonight's Pick
                    if let pick = tonightsPick {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tonight's Pick")
                                .font(.headline)
                                .padding(.horizontal)

                            LargeFeatureCard(
                                cocktail: pick.cocktail,
                                canMake: pick.canMake
                            ) {
                                selectedCocktail = pick.cocktail
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: - One Away
                    if !almostMatches.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("One Away")
                                    .font(.headline)
                                Spacer()
                                Text("Missing 1 ingredient")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(almostMatches.prefix(10)) { match in
                                        OneAwayCard(match: match) {
                                            selectedCocktail = match.cocktail
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // MARK: - Low Stock Warning
                    let lowBottles = bottles.filter { $0.isLow && !$0.isEmpty }
                    if !lowBottles.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Running Low")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(lowBottles) { bottle in
                                HStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.orange)
                                    VStack(alignment: .leading) {
                                        Text(bottle.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text(bottle.ingredientName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    BottleLevelView(level: bottle.level)
                                        .frame(width: 60)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // MARK: - Empty State
                    if bottles.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "wineglass")
                                .font(.system(size: 48))
                                .foregroundStyle(AppTheme.amber)

                            Text("Welcome to Barback")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text("Start by adding the bottles in your home bar. We'll tell you what cocktails you can make.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button {
                                showingAddBottle = true
                            } label: {
                                Label("Add Your First Bottle", systemImage: "plus.circle.fill")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.amber)
                        }
                        .padding(32)
                        .frame(maxWidth: .infinity)
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top)
            }
            .navigationTitle("Barback")
            .sheet(isPresented: $showingAddBottle) {
                AddBottleSheet()
            }
            .sheet(item: $selectedCocktail) { cocktail in
                NavigationStack {
                    CocktailDetailView(cocktail: cocktail, inventory: inventory)
                }
            }
        }
    }

    private var tonightsPick: CocktailMatch? {
        // Deterministic "random" based on the day
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        if !canMakeMatches.isEmpty {
            return canMakeMatches[day % canMakeMatches.count]
        }
        let allMatches = MatchEngine.sortedMatches(inventory: inventory)
        if !allMatches.isEmpty {
            return allMatches[day % min(5, allMatches.count)]
        }
        let idx = day % CocktailDatabase.all.count
        return MatchEngine.match(cocktail: CocktailDatabase.all[idx], inventory: inventory)
    }
}

// MARK: - One Away Card

private struct OneAwayCard: View {
    let match: CocktailMatch
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: match.cocktail.glass.icon)
                    .font(.title2)
                    .foregroundStyle(match.cocktail.category.color)

                Text(match.cocktail.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if let missing = match.missingIngredients.first {
                    Text("Need: \(missing)")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .lineLimit(2)
                }
            }
            .padding(12)
            .frame(width: 130, alignment: .leading)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
