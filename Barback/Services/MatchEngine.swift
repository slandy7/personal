import Foundation

enum MatchEngine {
    // MARK: - Substitution Map

    /// Maps an ingredient to acceptable substitutes.
    static let substitutions: [String: Set<String>] = [
        // Whiskey family
        "Bourbon": ["Rye Whiskey"],
        "Rye Whiskey": ["Bourbon"],
        "Scotch": ["Irish Whiskey"],
        "Irish Whiskey": ["Scotch"],

        // Rum family
        "White Rum": ["Aged Rum"],
        "Dark Rum": ["Aged Rum"],
        "Aged Rum": ["Dark Rum"],

        // Tequila family
        "Tequila Blanco": ["Tequila Reposado", "Mezcal"],
        "Tequila Reposado": ["Tequila Blanco", "Tequila Añejo"],
        "Mezcal": ["Tequila Blanco", "Tequila Reposado"],

        // Orange liqueur family
        "Triple Sec": ["Cointreau", "Grand Marnier", "Orange Curaçao"],
        "Cointreau": ["Triple Sec", "Grand Marnier", "Orange Curaçao"],
        "Grand Marnier": ["Cointreau", "Triple Sec", "Orange Curaçao"],
        "Orange Curaçao": ["Cointreau", "Triple Sec", "Grand Marnier"],

        // Brandy family
        "Brandy": ["Cognac"],
        "Cognac": ["Brandy"],

        // Syrup family
        "Simple Syrup": ["Rich Simple Syrup", "Demerara Syrup", "Sugar"],
        "Rich Simple Syrup": ["Simple Syrup", "Demerara Syrup"],
        "Demerara Syrup": ["Simple Syrup", "Rich Simple Syrup"],
        "Sugar": ["Simple Syrup"],

        // Sparkling wine
        "Champagne": ["Prosecco"],
        "Prosecco": ["Champagne"],

        // Vermouth near-substitutes
        "Lillet Blanc": ["Dry Vermouth"],

        // Elderflower
        "Elderflower Liqueur": ["St-Germain"],

        // Soda
        "Club Soda": ["Tonic Water"],
    ]

    // MARK: - Match a Single Cocktail

    static func match(cocktail: Cocktail, inventory: Set<String>) -> CocktailMatch {
        var available = Set<String>()
        var missing: [String] = []
        var missingOptional: [String] = []

        for ingredient in cocktail.ingredients {
            let found = inventoryHas(ingredient: ingredient.name, inventory: inventory)
            if found {
                available.insert(ingredient.name)
            } else if ingredient.isOptional {
                missingOptional.append(ingredient.name)
            } else {
                missing.append(ingredient.name)
            }
        }

        return CocktailMatch(
            cocktail: cocktail,
            availableIngredients: available,
            missingIngredients: missing,
            missingOptional: missingOptional
        )
    }

    // MARK: - Match All Cocktails

    static func matchAll(inventory: Set<String>) -> [CocktailMatch] {
        CocktailDatabase.all.map { match(cocktail: $0, inventory: inventory) }
    }

    // MARK: - Helpers

    /// Check if the inventory contains the given ingredient (directly or via substitution).
    private static func inventoryHas(ingredient: String, inventory: Set<String>) -> Bool {
        if inventory.contains(ingredient) { return true }

        // Check substitutions
        if let subs = substitutions[ingredient] {
            for sub in subs {
                if inventory.contains(sub) { return true }
            }
        }

        return false
    }

    // MARK: - Convenience Queries

    /// Cocktails the user can make right now.
    static func canMake(inventory: Set<String>) -> [CocktailMatch] {
        matchAll(inventory: inventory)
            .filter { $0.canMake }
            .sorted { $0.cocktail.name < $1.cocktail.name }
    }

    /// Cocktails missing exactly 1 ingredient.
    static func almostCanMake(inventory: Set<String>) -> [CocktailMatch] {
        matchAll(inventory: inventory)
            .filter { $0.missingCount == 1 }
            .sorted { $0.cocktail.name < $1.cocktail.name }
    }

    /// Sorted matches: can-make first, then by match percentage descending.
    static func sortedMatches(inventory: Set<String>) -> [CocktailMatch] {
        matchAll(inventory: inventory)
            .sorted {
                if $0.canMake != $1.canMake { return $0.canMake }
                if $0.matchPercentage != $1.matchPercentage {
                    return $0.matchPercentage > $1.matchPercentage
                }
                return $0.cocktail.name < $1.cocktail.name
            }
    }
}
