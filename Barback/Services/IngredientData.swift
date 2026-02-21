import Foundation

struct IngredientInfo: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let category: BottleCategory
}

enum IngredientData {
    // MARK: - All Known Ingredients

    static let all: [IngredientInfo] = {
        var list: [IngredientInfo] = []
        for (category, names) in byCategory {
            for name in names {
                list.append(IngredientInfo(name: name, category: category))
            }
        }
        return list.sorted { $0.name < $1.name }
    }()

    static let byCategory: [BottleCategory: [String]] = [
        .spirit: [
            "Absinthe",
            "Aged Rum",
            "Bourbon",
            "Brandy",
            "Cachaça",
            "Cognac",
            "Dark Rum",
            "Gin",
            "Irish Whiskey",
            "Mezcal",
            "Overproof Rum",
            "Pisco",
            "Rye Whiskey",
            "Scotch",
            "Tequila Añejo",
            "Tequila Blanco",
            "Tequila Reposado",
            "Vodka",
            "White Rum",
        ],
        .liqueur: [
            "Allspice Dram",
            "Amaretto",
            "Amaro Nonino",
            "Aperol",
            "Bénédictine",
            "Campari",
            "Chambord",
            "Cherry Heering",
            "Coffee Liqueur",
            "Cointreau",
            "Crème de Cacao",
            "Crème de Cassis",
            "Crème de Menthe",
            "Crème de Violette",
            "Cynar",
            "Drambuie",
            "Elderflower Liqueur",
            "St-Germain",
            "Falernum",
            "Fernet-Branca",
            "Galliano",
            "Grand Marnier",
            "Green Chartreuse",
            "Irish Cream",
            "Maraschino Liqueur",
            "Midori",
            "Orange Curaçao",
            "Sloe Gin",
            "Suze",
            "Triple Sec",
            "Yellow Chartreuse",
        ],
        .vermouthWine: [
            "Blanc Vermouth",
            "Champagne",
            "Dry Vermouth",
            "Lillet Blanc",
            "Port",
            "Prosecco",
            "Red Wine",
            "Sherry",
            "Sweet Vermouth",
        ],
        .syrup: [
            "Agave Syrup",
            "Cinnamon Syrup",
            "Demerara Syrup",
            "Ginger Syrup",
            "Grenadine",
            "Honey Syrup",
            "Orgeat",
            "Passion Fruit Syrup",
            "Raspberry Syrup",
            "Rich Simple Syrup",
            "Simple Syrup",
            "Vanilla Syrup",
        ],
        .juice: [
            "Cranberry Juice",
            "Grapefruit Juice",
            "Lemon Juice",
            "Lime Juice",
            "Orange Juice",
            "Pineapple Juice",
            "Tomato Juice",
        ],
        .mixer: [
            "Club Soda",
            "Coconut Cream",
            "Cola",
            "Espresso",
            "Ginger Ale",
            "Ginger Beer",
            "Hot Water",
            "Tonic Water",
        ],
        .bitter: [
            "Angostura Bitters",
            "Aromatic Bitters",
            "Chocolate Bitters",
            "Orange Bitters",
            "Peychaud's Bitters",
        ],
        .garnish: [
            "Cinnamon",
            "Cucumber",
            "Egg White",
            "Heavy Cream",
            "Horseradish",
            "Maraschino Cherry",
            "Mint",
            "Nutmeg",
            "Olive",
            "Pepper",
            "Salt",
            "Sugar",
            "Tabasco",
            "Worcestershire Sauce",
        ],
    ]

    // MARK: - Lookup

    static func category(for ingredientName: String) -> BottleCategory {
        let lowered = ingredientName.lowercased()
        for (category, names) in byCategory {
            if names.contains(where: { $0.lowercased() == lowered }) {
                return category
            }
        }
        return .other
    }

    static func search(_ query: String) -> [IngredientInfo] {
        guard !query.isEmpty else { return all }
        let lowered = query.lowercased()
        return all.filter { $0.name.lowercased().contains(lowered) }
    }

    static let allNames: Set<String> = {
        Set(all.map { $0.name })
    }()
}
