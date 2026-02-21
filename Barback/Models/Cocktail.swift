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

    /// Scale the amount string by a multiplier (e.g. 0.5, 2.0).
    func scaled(by factor: Double) -> CocktailIngredient {
        CocktailIngredient(name, Self.scaleAmount(amount, by: factor), isOptional: isOptional)
    }

    /// Smartly scale amount strings like "2 oz", "0.75 oz", "3 dashes", "rinse".
    static func scaleAmount(_ amount: String, by factor: Double) -> String {
        guard factor != 1.0 else { return amount }

        let lowered = amount.lowercased()
        let unscalable = ["rinse", "float", "pinch", "to taste", "top", "splash"]
        for term in unscalable {
            if lowered.contains(term) { return amount }
        }

        guard let regex = try? NSRegularExpression(pattern: "\\d+\\.?\\d*") else { return amount }
        let nsString = amount as NSString
        let matches = regex.matches(in: amount, range: NSRange(location: 0, length: nsString.length))

        guard !matches.isEmpty else { return amount }

        var result = amount
        for match in matches.reversed() {
            let range = match.range
            let numStr = nsString.substring(with: range)
            guard let num = Double(numStr) else { continue }
            let scaled = num * factor
            let formatted: String
            if scaled.truncatingRemainder(dividingBy: 1) == 0 {
                formatted = String(Int(scaled))
            } else {
                formatted = String(format: "%.2g", scaled)
            }
            if let swiftRange = Range(range, in: result) {
                result = result.replacingCharacters(in: swiftRange, with: formatted)
            }
        }

        return result
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

    func scaledIngredients(by factor: Double) -> [CocktailIngredient] {
        ingredients.map { $0.scaled(by: factor) }
    }

    /// Plain-text recipe for sharing.
    var shareText: String {
        var lines: [String] = []
        lines.append(name)
        lines.append(String(repeating: "─", count: name.count))
        lines.append("")
        lines.append("Glass: \(glass.rawValue)")
        if ibaOfficial { lines.append("IBA Official Cocktail") }
        lines.append("")
        lines.append("Ingredients:")
        for ing in ingredients {
            let opt = ing.isOptional ? " (optional)" : ""
            lines.append("  \(ing.amount)  \(ing.name)\(opt)")
        }
        lines.append("")
        lines.append("Instructions:")
        for (i, step) in instructions.enumerated() {
            lines.append("  \(i + 1). \(step)")
        }
        if !garnish.isEmpty && garnish != "None" {
            lines.append("")
            lines.append("Garnish: \(garnish)")
        }
        lines.append("")
        lines.append(description)
        return lines.joined(separator: "\n")
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
