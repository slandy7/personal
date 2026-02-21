import SwiftUI
import SwiftData

struct CocktailListView: View {
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @State private var searchText = ""
    @State private var filterMode: FilterMode = .all
    @State private var selectedCategory: CocktailCategory?
    @State private var selectedDifficulty: CocktailDifficulty?
    @State private var selectedGlass: GlassType?
    @State private var selectedCocktail: Cocktail?
    @State private var showFilterSheet = false

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

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            matches = matches.filter { match in
                match.cocktail.name.lowercased().contains(query) ||
                match.cocktail.ingredients.contains { $0.name.lowercased().contains(query) } ||
                match.cocktail.description.lowercased().contains(query)
            }
        }

        switch filterMode {
        case .all:
            break
        case .canMake:
            matches = matches.filter { $0.canMake }
        case .favorites:
            matches = matches.filter { favorites.isFavorite($0.cocktail.id) }
        }

        if let category = selectedCategory {
            matches = matches.filter { $0.cocktail.category == category }
        }

        if let difficulty = selectedDifficulty {
            matches = matches.filter { $0.cocktail.difficulty == difficulty }
        }

        if let glass = selectedGlass {
            matches = matches.filter { $0.cocktail.glass == glass }
        }

        return matches
    }

    private var canMakeCount: Int {
        allMatches.filter { $0.canMake }.count
    }

    private var activeFilterCount: Int {
        (selectedCategory != nil ? 1 : 0) +
        (selectedDifficulty != nil ? 1 : 0) +
        (selectedGlass != nil ? 1 : 0)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Filter Bar
                VStack(spacing: 12) {
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
                            Button {
                                selectedCocktail = match.cocktail
                            } label: {
                                CocktailRowView(
                                    match: match,
                                    isFavorite: favorites.isFavorite(match.cocktail.id)
                                )
                            }
                            .buttonStyle(.plain)
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: activeFilterCount > 0
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(item: $selectedCocktail) { cocktail in
                NavigationStack {
                    CocktailDetailView(cocktail: cocktail, inventory: inventory)
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheet(
                    selectedDifficulty: $selectedDifficulty,
                    selectedGlass: $selectedGlass
                )
                .presentationDetents([.medium])
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

// MARK: - Filter Sheet

private struct FilterSheet: View {
    @Binding var selectedDifficulty: CocktailDifficulty?
    @Binding var selectedGlass: GlassType?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    HStack(spacing: 8) {
                        DifficultyPill(label: "Any", isSelected: selectedDifficulty == nil) {
                            selectedDifficulty = nil
                        }
                        ForEach([CocktailDifficulty.easy, .medium, .advanced], id: \.self) { diff in
                            DifficultyPill(label: diff.rawValue, isSelected: selectedDifficulty == diff) {
                                selectedDifficulty = selectedDifficulty == diff ? nil : diff
                            }
                        }
                    }
                }

                Section("Glass Type") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 8) {
                        GlassPill(glass: nil, isSelected: selectedGlass == nil) {
                            selectedGlass = nil
                        }
                        ForEach(GlassType.allCases) { glass in
                            GlassPill(glass: glass, isSelected: selectedGlass == glass) {
                                selectedGlass = selectedGlass == glass ? nil : glass
                            }
                        }
                    }
                }

                if selectedDifficulty != nil || selectedGlass != nil {
                    Section {
                        Button("Clear All Filters") {
                            selectedDifficulty = nil
                            selectedGlass = nil
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct DifficultyPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.amber.opacity(0.2) : Color.secondary.opacity(0.1))
                .foregroundStyle(isSelected ? AppTheme.amber : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct GlassPill: View {
    let glass: GlassType?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: glass?.icon ?? "list.bullet")
                    .font(.caption)
                Text(glass?.rawValue ?? "Any")
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.amber.opacity(0.2) : Color.secondary.opacity(0.1))
            .foregroundStyle(isSelected ? AppTheme.amber : .secondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Cocktail Row

struct CocktailRowView: View {
    let match: CocktailMatch
    let isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
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
                            .font(.system(.caption2, weight: .bold))
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(match.cocktail.name), \(match.canMake ? "ready to make" : "missing \(match.missingCount) ingredients")")
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
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    CocktailListView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self, CocktailLog.self], inMemory: true)
}
