import SwiftUI
import SwiftData

struct CocktailDetailView: View {
    let cocktail: Cocktail
    let inventory: Set<String>
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private let favorites = FavoritesManager.shared

    private var match: CocktailMatch {
        MatchEngine.match(cocktail: cocktail, inventory: inventory)
    }

    private var isFavorite: Bool {
        favorites.isFavorite(cocktail.id)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Header
                headerSection

                Divider().padding(.horizontal)

                // MARK: - Ingredients
                ingredientsSection

                Divider().padding(.horizontal)

                // MARK: - Instructions
                instructionsSection

                // MARK: - Add Missing to Shopping
                if !match.missingIngredients.isEmpty {
                    Divider().padding(.horizontal)
                    addToShoppingSection
                }

                // MARK: - About
                Divider().padding(.horizontal)
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
            ToolbarItem(placement: .primaryAction) {
                Button {
                    favorites.toggle(cocktail.id)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .pink : .secondary)
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 16) {
            // Glass icon and status
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

            // Can make badge
            if match.canMake {
                Label("You can make this!", systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Capsule())
            } else {
                Label(
                    "Missing \(match.missingCount) ingredient\(match.missingCount == 1 ? "" : "s")",
                    systemImage: "exclamationmark.circle"
                )
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.orange)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(Array(cocktail.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    let isMissing = match.missingIngredients.contains(ingredient.name)
                    let isAvailable = match.availableIngredients.contains(ingredient.name)

                    HStack(spacing: 12) {
                        // Status icon
                        if isAvailable {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                        } else if ingredient.isOptional {
                            Image(systemName: "circle.dashed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }

                        Text(ingredient.amount)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .frame(width: 70, alignment: .trailing)

                        Text(ingredient.name)
                            .font(.subheadline)
                            .foregroundStyle(isMissing ? .red : .primary)

                        if ingredient.isOptional {
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
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    if index < cocktail.ingredients.count - 1 {
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

            // Garnish
            if !cocktail.garnish.isEmpty && cocktail.garnish != "None" {
                HStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
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
                            .foregroundStyle(.orange)
                        Text(ingredient)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }

            Button {
                addMissingToShoppingList()
            } label: {
                Label("Add All to Shopping List", systemImage: "cart.fill.badge.plus")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
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
        for ingredientName in match.missingIngredients {
            let category = IngredientData.category(for: ingredientName)
            let item = ShoppingItem(name: ingredientName, category: category)
            modelContext.insert(item)
        }
    }
}

#Preview {
    NavigationStack {
        CocktailDetailView(
            cocktail: CocktailDatabase.all[0],
            inventory: ["Bourbon", "Simple Syrup"]
        )
    }
    .modelContainer(for: [Bottle.self, ShoppingItem.self], inMemory: true)
}
