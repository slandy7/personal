import SwiftUI
import SwiftData

struct BottleDetailSheet: View {
    @Bindable var bottle: Bottle
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showIngredientPicker = false

    private let commonVolumes = [50, 200, 350, 375, 500, 700, 750, 1000, 1750]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Bottle Visual
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            BottleShapeView(
                                level: bottle.level,
                                color: bottle.category.color
                            )
                            .frame(width: 60, height: 120)

                            Text(bottle.levelDescription)
                                .font(.caption)
                                .foregroundStyle(AppTheme.levelColor(for: bottle.level))
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Bottle level: \(bottle.levelDescription), \(Int(bottle.level * 100)) percent")
                }

                // MARK: - Info
                Section("Bottle Info") {
                    TextField("Name", text: $bottle.name)
                        .textInputAutocapitalization(.words)

                    Button {
                        showIngredientPicker = true
                    } label: {
                        HStack {
                            Text("Type")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(bottle.ingredientName)
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    Picker("Category", selection: Binding(
                        get: { bottle.category },
                        set: { bottle.category = $0 }
                    )) {
                        ForEach(BottleCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // MARK: - Volume & ABV
                Section("Details") {
                    HStack {
                        Text("Volume")
                        Spacer()
                        Menu {
                            ForEach(commonVolumes, id: \.self) { vol in
                                Button {
                                    bottle.volumeML = vol
                                } label: {
                                    HStack {
                                        Text(volumeDisplayString(for: vol))
                                        if vol == bottle.volumeML {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text(bottle.volumeDisplayString)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Text("ABV")
                        Spacer()
                        TextField("0", value: $bottle.abv, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                        Text("%")
                            .foregroundStyle(.secondary)
                    }

                    if let purchaseDate = bottle.purchaseDate {
                        LabeledContent("Purchased") {
                            Text(purchaseDate, format: .dateTime.month().day().year())
                        }
                    }
                }

                // MARK: - Level Control
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Level")
                            Spacer()
                            Text("\(Int(bottle.level * 100))%")
                                .foregroundStyle(AppTheme.levelColor(for: bottle.level))
                                .fontWeight(.medium)
                        }

                        Slider(value: $bottle.level, in: 0...1, step: 0.05)
                            .tint(AppTheme.levelColor(for: bottle.level))

                        BottleLevelView(level: bottle.level, height: 10)
                    }

                    // Quick level buttons
                    HStack(spacing: 12) {
                        QuickLevelButton(label: "Empty", level: 0, current: $bottle.level)
                        QuickLevelButton(label: "¼", level: 0.25, current: $bottle.level)
                        QuickLevelButton(label: "½", level: 0.5, current: $bottle.level)
                        QuickLevelButton(label: "¾", level: 0.75, current: $bottle.level)
                        QuickLevelButton(label: "Full", level: 1.0, current: $bottle.level)
                    }
                } header: {
                    Text("Bottle Level")
                }

                // MARK: - Notes
                Section("Notes") {
                    TextField("Notes...", text: $bottle.notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                // MARK: - Metadata
                Section("Info") {
                    LabeledContent("Added") {
                        Text(bottle.dateAdded, format: .dateTime.month().day().year())
                    }

                    LabeledContent("Favorite") {
                        Button {
                            bottle.isFavorite.toggle()
                        } label: {
                            Image(systemName: bottle.isFavorite ? "star.fill" : "star")
                                .foregroundStyle(bottle.isFavorite ? .yellow : .gray)
                        }
                    }
                }

                // MARK: - Delete
                Section {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Delete Bottle", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(bottle.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        bottle.abv = min(max(bottle.abv, 0), 100)
                        dismiss()
                    }
                    .disabled(bottle.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .confirmationDialog(
                "Delete \(bottle.name)?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(bottle)
                    dismiss()
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .sheet(isPresented: $showIngredientPicker) {
                IngredientPickerSheet(
                    selectedIngredient: $bottle.ingredientName,
                    selectedCategory: Binding(
                        get: { bottle.category },
                        set: { bottle.category = $0 }
                    )
                )
            }
        }
    }

    private func volumeDisplayString(for ml: Int) -> String {
        if ml >= 1000 {
            let liters = Double(ml) / 1000.0
            return liters.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(liters))L"
                : String(format: "%.1fL", liters)
        }
        return "\(ml)ml"
    }
}

// MARK: - Quick Level Button

private struct QuickLevelButton: View {
    let label: String
    let level: Double
    @Binding var current: Double

    private var isSelected: Bool {
        abs(current - level) < 0.01
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                current = level
            }
        } label: {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.levelColor(for: level).opacity(0.2) : Color.secondary.opacity(0.1))
                .foregroundStyle(isSelected ? AppTheme.levelColor(for: level) : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label) level")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    let bottle = Bottle(name: "Maker's Mark", ingredientName: "Bourbon", category: .spirit, level: 0.65, volumeML: 750, abv: 45)
    BottleDetailSheet(bottle: bottle)
        .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
