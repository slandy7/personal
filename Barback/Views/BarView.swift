import SwiftUI
import SwiftData

struct BarView: View {
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddBottle = false
    @State private var searchText = ""
    @State private var selectedCategory: BottleCategory?
    @State private var selectedBottle: Bottle?
    @State private var bottleToDelete: Bottle?
    @State private var sortOrder: SortOrder = .name

    enum SortOrder: String, CaseIterable {
        case name = "Name"
        case category = "Category"
        case dateAdded = "Date Added"
        case level = "Level"
    }

    private var filteredBottles: [Bottle] {
        var result = bottles

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(query) ||
                $0.ingredientName.lowercased().contains(query)
            }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        switch sortOrder {
        case .name:
            result.sort { $0.name < $1.name }
        case .category:
            result.sort { $0.categoryRaw < $1.categoryRaw }
        case .dateAdded:
            result.sort { $0.dateAdded > $1.dateAdded }
        case .level:
            result.sort { $0.level > $1.level }
        }

        return result
    }

    private var groupedBottles: [(BottleCategory, [Bottle])] {
        let grouped = Dictionary(grouping: filteredBottles) { $0.category }
        return BottleCategory.allCases.compactMap { category in
            guard let items = grouped[category], !items.isEmpty else { return nil }
            return (category, items)
        }
    }

    private var activeCategories: [BottleCategory] {
        let cats = Set(bottles.map { $0.category })
        return BottleCategory.allCases.filter { cats.contains($0) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if bottles.isEmpty {
                    EmptyStateView(
                        icon: "wineglass",
                        title: "Your Bar is Empty",
                        subtitle: "Add bottles, mixers, and garnishes to see what cocktails you can make.",
                        buttonTitle: "Add Bottle",
                        action: { showingAddBottle = true }
                    )
                } else {
                    List {
                        // Category filter chips
                        if activeCategories.count > 1 {
                            Section {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        FilterChip(
                                            title: "All",
                                            icon: "tray.full.fill",
                                            isSelected: selectedCategory == nil,
                                            color: AppTheme.amber
                                        ) {
                                            withAnimation { selectedCategory = nil }
                                        }

                                        ForEach(activeCategories) { category in
                                            FilterChip(
                                                title: category.rawValue,
                                                icon: category.icon,
                                                isSelected: selectedCategory == category,
                                                color: category.color
                                            ) {
                                                withAnimation {
                                                    selectedCategory = selectedCategory == category ? nil : category
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }

                        // Bottles grouped by category
                        ForEach(groupedBottles, id: \.0) { category, items in
                            Section {
                                ForEach(items) { bottle in
                                    Button {
                                        selectedBottle = bottle
                                    } label: {
                                        BottleRowView(bottle: bottle)
                                    }
                                    .buttonStyle(.plain)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                bottleToDelete = bottle
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                bottle.isFavorite.toggle()
                                            } label: {
                                                Label(
                                                    bottle.isFavorite ? "Unfavorite" : "Favorite",
                                                    systemImage: bottle.isFavorite ? "star.slash" : "star.fill"
                                                )
                                            }
                                            .tint(.yellow)
                                        }
                                }
                            } header: {
                                Label(category.rawValue, systemImage: category.icon)
                                    .foregroundStyle(category.color)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Search bottles...")
                }
            }
            .navigationTitle("My Bar")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddBottle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        Picker("Sort By", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .sheet(isPresented: $showingAddBottle) {
                AddBottleSheet()
            }
            .sheet(item: $selectedBottle) { bottle in
                BottleDetailSheet(bottle: bottle)
            }
            .confirmationDialog(
                "Delete \(bottleToDelete?.name ?? "")?",
                isPresented: Binding(
                    get: { bottleToDelete != nil },
                    set: { if !$0 { bottleToDelete = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let bottle = bottleToDelete {
                        withAnimation { modelContext.delete(bottle) }
                    }
                    bottleToDelete = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}

// MARK: - Bottle Row

struct BottleRowView: View {
    let bottle: Bottle

    var body: some View {
        HStack(spacing: 12) {
            // Category color dot
            Circle()
                .fill(bottle.category.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(bottle.name)
                        .font(.body)
                        .fontWeight(.medium)

                    if bottle.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                    }
                }

                Text(bottle.ingredientName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            BottleLevelView(level: bottle.level)
                .frame(width: 50)

            Text("\(Int(bottle.level * 100))%")
                .font(.caption)
                .foregroundStyle(AppTheme.levelColor(for: bottle.level))
                .frame(width: 34, alignment: .trailing)
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(bottle.name), \(bottle.ingredientName), \(Int(bottle.level * 100)) percent full")
    }
}

// MARK: - Filter Chip

private struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color.opacity(0.2) : Color.clear)
                .foregroundStyle(isSelected ? color : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? color.opacity(0.5) : Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    BarView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
