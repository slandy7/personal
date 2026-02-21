import Foundation

// MARK: - Cocktail Recipe (static data)

struct CocktailIngredient: Codable, Hashable, Identifiable {
    var id: String { "\(name)-\(amount)" }
    let name: String
    let amount: String
    let isOptional: Bool

    init(_ name: String, _ amount: String, isOptional: Bool = false) {
        self.name = name
        self.amount = amount
        self.isOptional = isOptional
    }
}

struct Cocktail: Identifiable, Hashable {
    let id: String
    let name: String
    let ingredients: [CocktailIngredient]
    let instructions: [String]
    let glass: GlassType
    let garnish: String
    let category: CocktailCategory
    let difficulty: CocktailDifficulty
    let description: String
    let ibaOfficial: Bool

    var requiredIngredients: [CocktailIngredient] {
        ingredients.filter { !$0.isOptional }
    }

    var optionalIngredients: [CocktailIngredient] {
        ingredients.filter { $0.isOptional }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Match Result

struct CocktailMatch: Identifiable {
    let cocktail: Cocktail
    let availableIngredients: Set<String>
    let missingIngredients: [String]
    let missingOptional: [String]

    var id: String { cocktail.id }
    var canMake: Bool { missingIngredients.isEmpty }
    var missingCount: Int { missingIngredients.count }

    var totalRequired: Int {
        cocktail.requiredIngredients.count
    }

    var matchPercentage: Double {
        guard totalRequired > 0 else { return 0 }
        let available = totalRequired - missingCount
        return Double(available) / Double(totalRequired)
    }
}
