import SwiftUI
import SwiftData

struct AddBottleSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var ingredientName = ""
    @State private var category: BottleCategory = .spirit
    @State private var level: Double = 1.0
    @State private var notes = ""
    @State private var ingredientSearch = ""
    @State private var showIngredientPicker = false

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !ingredientName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Basic Info
                Section("Bottle Info") {
                    TextField("Brand name (e.g. Maker's Mark)", text: $name)
                        .textInputAutocapitalization(.words)

                    // Ingredient type selector
                    Button {
                        showIngredientPicker = true
                    } label: {
                        HStack {
                            Text("Type")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(ingredientName.isEmpty ? "Select..." : ingredientName)
                                .foregroundStyle(ingredientName.isEmpty ? .tertiary : .secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                // MARK: - Category (auto-detected but editable)
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(BottleCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // MARK: - Level
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Bottle Level")
                            Spacer()
                            Text("\(Int(level * 100))%")
                                .foregroundStyle(AppTheme.levelColor(for: level))
                                .fontWeight(.medium)
                        }
                        Slider(value: $level, in: 0...1, step: 0.05)
                            .tint(AppTheme.levelColor(for: level))

                        BottleLevelView(level: level, height: 10)
                    }
                } header: {
                    Text("Level")
                } footer: {
                    Text("How full is the bottle?")
                }

                // MARK: - Notes
                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Bottle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addBottle()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showIngredientPicker) {
                IngredientPickerSheet(
                    selectedIngredient: $ingredientName,
                    selectedCategory: $category
                )
            }
        }
    }

    private func addBottle() {
        let bottle = Bottle(
            name: name.trimmingCharacters(in: .whitespaces),
            ingredientName: ingredientName,
            category: category,
            level: level,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        modelContext.insert(bottle)
        dismiss()
    }
}

// MARK: - Ingredient Picker

struct IngredientPickerSheet: View {
    @Binding var selectedIngredient: String
    @Binding var selectedCategory: BottleCategory
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var filteredIngredients: [BottleCategory: [String]] {
        if searchText.isEmpty {
            return IngredientData.byCategory
        }
        let query = searchText.lowercased()
        var result: [BottleCategory: [String]] = [:]
        for (category, names) in IngredientData.byCategory {
            let filtered = names.filter { $0.lowercased().contains(query) }
            if !filtered.isEmpty {
                result[category] = filtered
            }
        }
        return result
    }

    private var sortedCategories: [BottleCategory] {
        BottleCategory.allCases.filter { filteredIngredients[$0] != nil }
    }

    var body: some View {
        NavigationStack {
            List {
                if !searchText.isEmpty && filteredIngredients.isEmpty {
                    // Allow custom ingredient
                    Section {
                        Button {
                            selectedIngredient = searchText
                            selectedCategory = .other
                            dismiss()
                        } label: {
                            Label("Use \"\(searchText)\"", systemImage: "plus.circle")
                        }
                    } header: {
                        Text("Custom Ingredient")
                    }
                }

                ForEach(sortedCategories) { category in
                    Section {
                        ForEach(filteredIngredients[category] ?? [], id: \.self) { name in
                            Button {
                                selectedIngredient = name
                                selectedCategory = category
                                dismiss()
                            } label: {
                                HStack {
                                    Text(name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if name == selectedIngredient {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(AppTheme.amber)
                                    }
                                }
                            }
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.icon)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search ingredients...")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AddBottleSheet()
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
