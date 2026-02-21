import SwiftUI
import SwiftData

struct CocktailListView: View {
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @State private var searchText = ""
    @State private var filterMode: FilterMode = .all
    @State private var selectedCategory: CocktailCategory?
    @State private var selectedCocktail: Cocktail?

    private let favorites = FavoritesManager.shared

    enum FilterMode: String, CaseIterable {
        case all = "All"
        case canMake = "Can Make"
        case favorites = "Favorites"
    }

    private var inventory: Set<String> {
        Set(bottles.filter { $0.level > 0 }.map { $0.ingredientName })
    }

    private var allMatches: [CocktailMatch] {
        MatchEngine.sortedMatches(inventory: inventory)
    }

    private var filteredMatches: [CocktailMatch] {
        var matches = allMatches

        // Search filter
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            matches = matches.filter { match in
                match.cocktail.name.lowercased().contains(query) ||
                match.cocktail.ingredients.contains { $0.name.lowercased().contains(query) } ||
                match.cocktail.description.lowercased().contains(query)
            }
        }

        // Mode filter
        switch filterMode {
        case .all:
            break
        case .canMake:
            matches = matches.filter { $0.canMake }
        case .favorites:
            matches = matches.filter { favorites.isFavorite($0.cocktail.id) }
        }

        // Category filter
        if let category = selectedCategory {
            matches = matches.filter { $0.cocktail.category == category }
        }

        return matches
    }

    private var canMakeCount: Int {
        allMatches.filter { $0.canMake }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Filter Bar
                VStack(spacing: 12) {
                    // Mode picker
                    Picker("Filter", selection: $filterMode) {
                        ForEach(FilterMode.allCases, id: \.self) { mode in
                            switch mode {
                            case .all:
                                Text("All \(CocktailDatabase.count)")
                            case .canMake:
                                Text("Can Make \(canMakeCount)")
                            case .favorites:
                                Text("Favorites")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Category scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(
                                category: nil,
                                isSelected: selectedCategory == nil,
                                action: { withAnimation { selectedCategory = nil } }
                            )
                            ForEach(CocktailCategory.allCases) { category in
                                CategoryChip(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: {
                                        withAnimation {
                                            selectedCategory = selectedCategory == category ? nil : category
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
                .background(.bar)

                // MARK: - Cocktail List
                if filteredMatches.isEmpty {
                    Spacer()
                    emptyContent
                    Spacer()
                } else {
                    List {
                        ForEach(filteredMatches) { match in
                            CocktailRowView(
                                match: match,
                                isFavorite: favorites.isFavorite(match.cocktail.id)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCocktail = match.cocktail
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    favorites.toggle(match.cocktail.id)
                                } label: {
                                    Label(
                                        favorites.isFavorite(match.cocktail.id) ? "Unfavorite" : "Favorite",
                                        systemImage: "heart.fill"
                                    )
                                }
                                .tint(.pink)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Cocktails")
            .searchable(text: $searchText, prompt: "Search cocktails or ingredients...")
            .sheet(item: $selectedCocktail) { cocktail in
                NavigationStack {
                    CocktailDetailView(cocktail: cocktail, inventory: inventory)
                }
            }
        }
    }

    @ViewBuilder
    private var emptyContent: some View {
        switch filterMode {
        case .all:
            if !searchText.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Results",
                    subtitle: "No cocktails match \"\(searchText)\"."
                )
            }
        case .canMake:
            EmptyStateView(
                icon: "wineglass",
                title: "Add More to Your Bar",
                subtitle: bottles.isEmpty
                    ? "Start adding bottles to discover what you can make."
                    : "You need a few more ingredients to start mixing."
            )
        case .favorites:
            EmptyStateView(
                icon: "heart",
                title: "No Favorites Yet",
                subtitle: "Swipe right on a cocktail to add it to your favorites."
            )
        }
    }
}

// MARK: - Cocktail Row

struct CocktailRowView: View {
    let match: CocktailMatch
    let isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Glass icon
            Image(systemName: match.cocktail.glass.icon)
                .font(.title3)
                .foregroundStyle(match.cocktail.category.color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(match.cocktail.name)
                        .font(.body)
                        .fontWeight(.medium)

                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundStyle(.pink)
                    }

                    if match.cocktail.ibaOfficial {
                        Text("IBA")
                            .font(.system(size: 8, weight: .bold))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                }

                Text(match.cocktail.ingredients.map { $0.name }.joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Status badge
            if match.canMake {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else if match.missingCount <= 2 {
                Text("-\(match.missingCount)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Category Chip

private struct CategoryChip: View {
    let category: CocktailCategory?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: category?.icon ?? "list.bullet")
                    .font(.caption2)
                Text(category?.rawValue ?? "All")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? (category?.color ?? AppTheme.amber).opacity(0.2) : Color.clear)
            .foregroundStyle(isSelected ? (category?.color ?? AppTheme.amber) : .secondary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? (category?.color ?? AppTheme.amber).opacity(0.5) : Color.secondary.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CocktailListView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
