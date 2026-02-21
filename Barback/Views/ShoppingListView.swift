import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Query(sort: \ShoppingItem.dateAdded) private var items: [ShoppingItem]
    @Query(sort: \Bottle.name) private var bottles: [Bottle]
    @Environment(\.modelContext) private var modelContext
    @State private var newItemName = ""
    @State private var showSuggestions = false

    private var inventory: Set<String> {
        Set(bottles.filter { $0.level > 0 }.map { $0.ingredientName })
    }

    private var pendingItems: [ShoppingItem] {
        items.filter { !$0.isCompleted }
    }

    private var completedItems: [ShoppingItem] {
        items.filter { $0.isCompleted }
    }

    /// Ingredients that would unlock the most new cocktails.
    private var smartSuggestions: [(ingredient: String, unlocksCount: Int)] {
        let allMatches = MatchEngine.matchAll(inventory: inventory)
        let almostMakeable = allMatches.filter { $0.missingCount == 1 }

        // Count how many cocktails each missing ingredient would unlock
        var unlockCounts: [String: Int] = [:]
        for match in almostMakeable {
            for missing in match.missingIngredients {
                unlockCounts[missing, default: 0] += 1
            }
        }

        // Already in shopping list
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

                        // MARK: - Pending Items
                        if !pendingItems.isEmpty {
                            Section {
                                ForEach(pendingItems) { item in
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
                                Text("To Buy (\(pendingItems.count))")
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
                            Button(role: .destructive) {
                                clearCompleted()
                            } label: {
                                Label("Clear Completed", systemImage: "checkmark.circle")
                            }
                            .disabled(completedItems.isEmpty)

                            Button(role: .destructive) {
                                clearAll()
                            } label: {
                                Label("Clear All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
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
    let item: ShoppingItem
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

            if !item.notes.isEmpty {
                Image(systemName: "note.text")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
