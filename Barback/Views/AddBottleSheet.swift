import SwiftUI
import SwiftData

struct AddBottleSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Bottle.name) private var existingBottles: [Bottle]

    @State private var name = ""
    @State private var ingredientName = ""
    @State private var category: BottleCategory = .spirit
    @State private var level: Double = 1.0
    @State private var notes = ""
    @State private var showIngredientPicker = false

    // New fields
    @State private var volumeML: Int = 750
    @State private var abv: Double = 0
    @State private var purchaseDate: Date = Date()
    @State private var trackPurchaseDate: Bool = false

    private let commonVolumes = [50, 200, 350, 375, 500, 700, 750, 1000, 1750]

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !ingredientName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var duplicateWarning: String? {
        let trimmed = name.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return nil }
        if existingBottles.contains(where: { $0.name.lowercased() == trimmed }) {
            return "You already have a bottle named \"\(name.trimmingCharacters(in: .whitespaces))\"."
        }
        if !ingredientName.isEmpty,
           existingBottles.contains(where: { $0.ingredientName == ingredientName }) {
            return "You already have \(ingredientName) in your bar."
        }
        return nil
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Basic Info
                Section("Bottle Info") {
                    TextField("Brand name (e.g. Maker's Mark)", text: $name)
                        .textInputAutocapitalization(.words)

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

                    if let warning = duplicateWarning {
                        Label(warning, systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.deepAmber)
                    }

                    Picker("Category", selection: $category) {
                        ForEach(BottleCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // MARK: - Volume & ABV
                Section {
                    HStack {
                        Text("Volume")
                        Spacer()
                        Menu {
                            ForEach(commonVolumes, id: \.self) { vol in
                                Button {
                                    volumeML = vol
                                } label: {
                                    HStack {
                                        Text(Bottle.volumeDisplay(for: vol))
                                        if vol == volumeML {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text(Bottle.volumeDisplay(for: volumeML))
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Text("ABV")
                        Spacer()
                        TextField("0", value: $abv, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                        Text("%")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Details")
                } footer: {
                    Text("Optional — helps track your collection.")
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

                // MARK: - Purchase Date
                Section {
                    Toggle("Track purchase date", isOn: $trackPurchaseDate)

                    if trackPurchaseDate {
                        DatePicker("Purchased", selection: $purchaseDate, displayedComponents: .date)
                    }
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
            notes: notes.trimmingCharacters(in: .whitespaces),
            volumeML: volumeML,
            abv: abv,
            purchaseDate: trackPurchaseDate ? purchaseDate : nil
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
