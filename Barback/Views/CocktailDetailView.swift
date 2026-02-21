import SwiftUI
import SwiftData

struct CocktailDetailView: View {
    let cocktail: Cocktail
    let inventory: Set<String>
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [CocktailLog]
    @Query private var shoppingItems: [ShoppingItem]

    @State private var scale: Double = 1.0
    @State private var showMadeItSheet = false
    @State private var addedToShoppingList = false

    private let favorites = FavoritesManager.shared

    private var match: CocktailMatch {
        MatchEngine.match(cocktail: cocktail, inventory: inventory)
    }

    private var isFavorite: Bool {
        favorites.isFavorite(cocktail.id)
    }

    private var displayIngredients: [CocktailIngredient] {
        cocktail.scaledIngredients(by: scale)
    }

    private var timesMade: Int {
        logs.filter { $0.cocktailId == cocktail.id }.count
    }

    private var lastMade: Date? {
        logs.filter { $0.cocktailId == cocktail.id }
            .sorted { $0.dateMade > $1.dateMade }
            .first?.dateMade
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                headerSection

                ingredientsSection

                scalePicker

                instructionsSection

                if !match.missingIngredients.isEmpty {
                    addToShoppingSection
                }

                madeItSection

                aboutSection

                Spacer(minLength: 32)
            }
        }
        .navigationTitle(cocktail.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(item: cocktail.shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                Button {
                    withAnimation { favorites.toggle(cocktail.id) }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? AppTheme.favorite : .secondary)
                        .symbolEffect(.bounce, value: isFavorite)
                }
            }
        }
        .sheet(isPresented: $showMadeItSheet) {
            MadeItSheet(cocktailId: cocktail.id)
        }
        .sensoryFeedback(.selection, trigger: scale)
        .sensoryFeedback(.success, trigger: addedToShoppingList)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(cocktail.category.color.opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: cocktail.glass.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(cocktail.category.color)
            }

            VStack(spacing: 6) {
                Text(cocktail.name)
                    .font(.title)
                    .fontWeight(.bold)

                HStack(spacing: 12) {
                    Label(cocktail.glass.rawValue, systemImage: "wineglass")
                    Label(cocktail.difficulty.rawValue, systemImage: "gauge.medium")
                    if cocktail.ibaOfficial {
                        Label("IBA", systemImage: "checkmark.seal")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            if match.canMake {
                Label("You can make this!", systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppTheme.statusReady)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppTheme.statusReady.opacity(0.1))
                    .clipShape(Capsule())
            } else {
                Label(
                    "Missing \(match.missingCount) ingredient\(match.missingCount == 1 ? "" : "s")",
                    systemImage: "exclamationmark.circle"
                )
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.statusMissing)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppTheme.statusMissing.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    // MARK: - Scale Picker

    private var scalePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Servings")
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach([0.5, 1.0, 2.0, 4.0, 8.0], id: \.self) { value in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) { scale = value }
                    } label: {
                        Text(value == 0.5 ? "½×" : "\(Int(value))×")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(scale == value ? cocktail.category.color.opacity(0.2) : Color.secondary.opacity(0.08))
                            .foregroundStyle(scale == value ? cocktail.category.color : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(value == 0.5 ? "Half serving" : "\(Int(value)) serving\(value > 1 ? "s" : "")")
                    .accessibilityAddTraits(scale == value ? .isSelected : [])
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(Array(displayIngredients.enumerated()), id: \.offset) { index, ingredient in
                    let originalIngredient = cocktail.ingredients[index]
                    let isMissing = match.missingIngredients.contains(originalIngredient.name)
                    let isAvailable = match.availableIngredients.contains(originalIngredient.name)
                    let substitutes = MatchEngine.allSubstitutes(for: originalIngredient.name)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 12) {
                            if isAvailable {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.statusReady)
                            } else if originalIngredient.isOptional {
                                Image(systemName: "circle.dashed")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.statusMissing)
                            }

                            Text(ingredient.amount)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .frame(width: 70, alignment: .trailing)

                            Text(originalIngredient.name)
                                .font(.subheadline)
                                .foregroundStyle(isMissing ? AppTheme.statusMissing : .primary)

                            if originalIngredient.isOptional {
                                Text("optional")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(Capsule())
                            }

                            Spacer()
                        }

                        // Substitution hints
                        if isMissing && !substitutes.isEmpty {
                            let owned = MatchEngine.availableSubstitutes(for: originalIngredient.name, inventory: inventory)
                            if !owned.isEmpty {
                                Text("You have: \(owned.joined(separator: ", "))")
                                    .font(.caption2)
                                    .foregroundStyle(AppTheme.statusReady)
                                    .padding(.leading, 100)
                            } else {
                                Text("Sub: \(substitutes.prefix(3).joined(separator: ", "))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 100)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    if index < displayIngredients.count - 1 {
                        Divider().padding(.leading, 52)
                    }
                }
            }
        }
    }

    // MARK: - Instructions

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(cocktail.instructions.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(cocktail.category.color)
                            .clipShape(Circle())

                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal)

            if !cocktail.garnish.isEmpty && cocktail.garnish != "None" {
                HStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundStyle(AppTheme.statusReady)
                        .frame(width: 22)

                    Text("Garnish: \(cocktail.garnish)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Add Missing to Shopping

    private var addToShoppingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Missing Ingredients")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 8) {
                ForEach(match.missingIngredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "cart.badge.plus")
                            .foregroundStyle(AppTheme.deepAmber)
                        Text(ingredient)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }

            Button {
                addMissingToShoppingList()
                withAnimation { addedToShoppingList = true }
            } label: {
                Label(
                    addedToShoppingList ? "Added to Shopping List" : "Add All to Shopping List",
                    systemImage: addedToShoppingList ? "checkmark" : "cart.fill.badge.plus"
                )
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(addedToShoppingList ? AppTheme.statusReady : AppTheme.deepAmber)
            .disabled(addedToShoppingList)
            .padding(.horizontal)
        }
    }

    // MARK: - Made It

    private var madeItSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if timesMade > 0 {
                Text("Your History")
                    .font(.headline)
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    VStack {
                        Text("\(timesMade)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Times made")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    if let date = lastMade {
                        VStack {
                            Text(date, format: .dateTime.month(.abbreviated).day())
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Last made")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }

            Button {
                showMadeItSheet = true
            } label: {
                Label("I Made This!", systemImage: "checkmark.seal.fill")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(cocktail.category.color)
            .padding(.horizontal)
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)
                .padding(.horizontal)

            Text(cocktail.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    // MARK: - Actions

    private func addMissingToShoppingList() {
        let existingNames = Set(shoppingItems.filter { !$0.isCompleted }.map { $0.name })
        for ingredientName in match.missingIngredients {
            guard !existingNames.contains(ingredientName) else { continue }
            let category = IngredientData.category(for: ingredientName)
            let item = ShoppingItem(name: ingredientName, category: category)
            modelContext.insert(item)
        }
    }
}

// MARK: - Made It Sheet

private struct MadeItSheet: View {
    let cocktailId: String
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("How was it?") {
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    rating = rating == star ? 0 : star
                                }
                            } label: {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundStyle(star <= rating ? AppTheme.amber : .secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .accessibilityElement()
                    .accessibilityLabel("Rating")
                    .accessibilityValue("\(rating) of 5 stars")
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment: rating = min(5, rating + 1)
                        case .decrement: rating = max(0, rating - 1)
                        @unknown default: break
                        }
                    }
                }

                Section("Notes") {
                    TextField("Tasting notes, adjustments...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Log It")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        logIt()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func logIt() {
        let log = CocktailLog(
            cocktailId: cocktailId,
            rating: rating,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        modelContext.insert(log)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        CocktailDetailView(
            cocktail: CocktailDatabase.all[0],
            inventory: ["Bourbon", "Simple Syrup"]
        )
    }
    .modelContainer(for: [Bottle.self, ShoppingItem.self, CocktailLog.self], inMemory: true)
}
