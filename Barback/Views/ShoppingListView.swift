import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Query(sort: \ShoppingItem.dateAdded) private var items: [ShoppingItem]
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @Environment(\.modelContext) private var modelContext
    @State private var newItemName = ""
    @State private var showSuggestions = false
    @State private var showClearConfirmation = false

    private var inventory: Set<String> {
        Set(bottles.filter { $0.level > 0 }.map { $0.ingredientName })
    }

    private var pendingItems: [ShoppingItem] {
        items.filter { !$0.isCompleted }
    }

    private var completedItems: [ShoppingItem] {
        items.filter { $0.isCompleted }
    }

    private var pendingGrouped: [(BottleCategory, [ShoppingItem])] {
        let grouped = Dictionary(grouping: pendingItems) { $0.category }
        return BottleCategory.allCases.compactMap { category in
            guard let group = grouped[category], !group.isEmpty else { return nil }
            return (category, group)
        }
    }

    private var totalPendingCount: Int {
        pendingItems.reduce(0) { $0 + $1.quantity }
    }

    /// Ingredients that would unlock the most new cocktails.
    private var smartSuggestions: [(ingredient: String, unlocksCount: Int)] {
        let allMatches = MatchEngine.matchAll(inventory: inventory)
        let almostMakeable = allMatches.filter { $0.missingCount == 1 }

        var unlockCounts: [String: Int] = [:]
        for match in almostMakeable {
            for missing in match.missingIngredients {
                unlockCounts[missing, default: 0] += 1
            }
        }

        let alreadyShopping = Set(items.map { $0.name })

        return unlockCounts
            .filter { !alreadyShopping.contains($0.key) }
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { (ingredient: $0.key, unlocksCount: $0.value) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty && smartSuggestions.isEmpty {
                    EmptyStateView(
                        icon: "cart",
                        title: "Shopping List Empty",
                        subtitle: "Add items manually or let Barback suggest what to buy based on your bar."
                    )
                } else {
                    List {
                        // MARK: - Add Item
                        Section {
                            HStack {
                                TextField("Add item...", text: $newItemName)
                                    .textInputAutocapitalization(.words)
                                    .onSubmit {
                                        addItem()
                                    }

                                if !newItemName.isEmpty {
                                    Button {
                                        addItem()
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(AppTheme.amber)
                                    }
                                }
                            }
                        }

                        // MARK: - Smart Suggestions
                        if !smartSuggestions.isEmpty && showSuggestions {
                            Section {
                                ForEach(smartSuggestions, id: \.ingredient) { suggestion in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(suggestion.ingredient)
                                                .font(.subheadline)
                                            Text("Unlocks \(suggestion.unlocksCount) cocktail\(suggestion.unlocksCount == 1 ? "" : "s")")
                                                .font(.caption)
                                                .foregroundStyle(.green)
                                        }

                                        Spacer()

                                        Button {
                                            addSuggestion(suggestion.ingredient)
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .foregroundStyle(AppTheme.amber)
                                        }
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("\(suggestion.ingredient), unlocks \(suggestion.unlocksCount) cocktails")
                                    .accessibilityHint("Double tap to add to shopping list")
                                }
                            } header: {
                                HStack {
                                    Label("Suggested", systemImage: "lightbulb.fill")
                                    Spacer()
                                    Button {
                                        withAnimation { showSuggestions = false }
                                    } label: {
                                        Text("Hide")
                                            .font(.caption)
                                    }
                                }
                            }
                        } else if !smartSuggestions.isEmpty {
                            Section {
                                Button {
                                    withAnimation { showSuggestions = true }
                                } label: {
                                    Label("Show Smart Suggestions", systemImage: "lightbulb.fill")
                                        .foregroundStyle(AppTheme.amber)
                                }
                            }
                        }

                        // MARK: - Pending Items (grouped by category)
                        if !pendingItems.isEmpty {
                            ForEach(pendingGrouped, id: \.0) { category, groupItems in
                                Section {
                                    ForEach(groupItems) { item in
                                        ShoppingItemRow(item: item) {
                                            withAnimation {
                                                item.isCompleted = true
                                            }
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    modelContext.delete(item)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                } header: {
                                    HStack {
                                        Label(category.rawValue, systemImage: category.icon)
                                            .foregroundStyle(category.color)
                                        Spacer()
                                        Text("\(groupItems.count)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }

                            // Summary
                            Section {
                                HStack {
                                    Text("\(pendingItems.count) item\(pendingItems.count == 1 ? "" : "s")")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    if totalPendingCount != pendingItems.count {
                                        Text("(\(totalPendingCount) total)")
                                            .font(.caption)
                                            .foregroundStyle(.tertiary)
                                    }
                                    Spacer()
                                    Button {
                                        completeAll()
                                    } label: {
                                        Text("Check All")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    .tint(AppTheme.amber)
                                }
                            }
                        }

                        // MARK: - Completed Items
                        if !completedItems.isEmpty {
                            Section {
                                ForEach(completedItems) { item in
                                    ShoppingItemRow(item: item) {
                                        withAnimation {
                                            item.isCompleted = false
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                modelContext.delete(item)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            } header: {
                                HStack {
                                    Text("Completed (\(completedItems.count))")
                                    Spacer()
                                    Button("Clear") {
                                        clearCompleted()
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            if !pendingItems.isEmpty {
                                Button {
                                    completeAll()
                                } label: {
                                    Label("Check All", systemImage: "checkmark.circle.fill")
                                }
                            }

                            if !completedItems.isEmpty {
                                Button {
                                    uncheckAll()
                                } label: {
                                    Label("Uncheck All", systemImage: "circle")
                                }
                            }

                            Divider()

                            if !completedItems.isEmpty {
                                Button(role: .destructive) {
                                    clearCompleted()
                                } label: {
                                    Label("Clear Completed", systemImage: "checkmark.circle")
                                }
                            }

                            Button(role: .destructive) {
                                showClearConfirmation = true
                            } label: {
                                Label("Clear All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .confirmationDialog("Clear entire shopping list?", isPresented: $showClearConfirmation, titleVisibility: .visible) {
                Button("Clear All", role: .destructive) {
                    clearAll()
                }
            } message: {
                Text("This will remove all \(items.count) items.")
            }
            .onAppear {
                showSuggestions = pendingItems.isEmpty
            }
        }
    }

    // MARK: - Actions

    private func addItem() {
        let name = newItemName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }

        let category = IngredientData.category(for: name)
        let item = ShoppingItem(name: name, category: category)
        modelContext.insert(item)
        newItemName = ""
    }

    private func addSuggestion(_ name: String) {
        let category = IngredientData.category(for: name)
        let item = ShoppingItem(name: name, category: category)
        modelContext.insert(item)
    }

    private func completeAll() {
        withAnimation {
            for item in pendingItems {
                item.isCompleted = true
            }
        }
    }

    private func uncheckAll() {
        withAnimation {
            for item in completedItems {
                item.isCompleted = false
            }
        }
    }

    private func clearCompleted() {
        withAnimation {
            for item in completedItems {
                modelContext.delete(item)
            }
        }
    }

    private func clearAll() {
        withAnimation {
            for item in items {
                modelContext.delete(item)
            }
        }
    }
}

// MARK: - Shopping Item Row

private struct ShoppingItemRow: View {
    @Bindable var item: ShoppingItem
    let toggleAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleAction) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                if item.category != .other {
                    Text(item.category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if !item.isCompleted {
                HStack(spacing: 4) {
                    if item.quantity > 1 {
                        Button {
                            item.quantity = max(1, item.quantity - 1)
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("×\(item.quantity)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(item.quantity > 1 ? AppTheme.amber : .secondary)
                        .frame(minWidth: 24)

                    Button {
                        item.quantity += 1
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), quantity \(item.quantity), \(item.isCompleted ? "completed" : "pending")")
        .accessibilityHint("Double tap to \(item.isCompleted ? "uncheck" : "check off")")
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self, CocktailLog.self], inMemory: true)
}
