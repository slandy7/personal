import Foundation

struct StarterBarItem {
    let name: String
    let ingredientName: String
    let category: BottleCategory
}

enum StarterBars {
    struct Template: Identifiable {
        let id: String
        let name: String
        let subtitle: String
        let icon: String
        let items: [StarterBarItem]
    }

    static let all: [Template] = [essentials, craftBar, tikiBar]

    static let essentials = Template(
        id: "essentials",
        name: "The Essentials",
        subtitle: "10 core items to make 20+ classics",
        icon: "star.fill",
        items: [
            StarterBarItem(name: "Vodka", ingredientName: "Vodka", category: .spirit),
            StarterBarItem(name: "Gin", ingredientName: "Gin", category: .spirit),
            StarterBarItem(name: "Bourbon", ingredientName: "Bourbon", category: .spirit),
            StarterBarItem(name: "White Rum", ingredientName: "White Rum", category: .spirit),
            StarterBarItem(name: "Tequila Blanco", ingredientName: "Tequila Blanco", category: .spirit),
            StarterBarItem(name: "Sweet Vermouth", ingredientName: "Sweet Vermouth", category: .vermouthWine),
            StarterBarItem(name: "Cointreau", ingredientName: "Cointreau", category: .liqueur),
            StarterBarItem(name: "Simple Syrup", ingredientName: "Simple Syrup", category: .syrup),
            StarterBarItem(name: "Angostura Bitters", ingredientName: "Angostura Bitters", category: .bitter),
            StarterBarItem(name: "Lemons", ingredientName: "Lemon Juice", category: .juice),
            StarterBarItem(name: "Limes", ingredientName: "Lime Juice", category: .juice),
        ]
    )

    static let craftBar = Template(
        id: "craft-bar",
        name: "Craft Cocktail Bar",
        subtitle: "22 items for a serious home bar",
        icon: "wand.and.stars",
        items: [
            // Spirits
            StarterBarItem(name: "Vodka", ingredientName: "Vodka", category: .spirit),
            StarterBarItem(name: "London Dry Gin", ingredientName: "Gin", category: .spirit),
            StarterBarItem(name: "Bourbon", ingredientName: "Bourbon", category: .spirit),
            StarterBarItem(name: "Rye Whiskey", ingredientName: "Rye Whiskey", category: .spirit),
            StarterBarItem(name: "White Rum", ingredientName: "White Rum", category: .spirit),
            StarterBarItem(name: "Aged Rum", ingredientName: "Aged Rum", category: .spirit),
            StarterBarItem(name: "Tequila Blanco", ingredientName: "Tequila Blanco", category: .spirit),
            StarterBarItem(name: "Mezcal", ingredientName: "Mezcal", category: .spirit),
            StarterBarItem(name: "Cognac", ingredientName: "Cognac", category: .spirit),
            // Liqueurs & Amari
            StarterBarItem(name: "Cointreau", ingredientName: "Cointreau", category: .liqueur),
            StarterBarItem(name: "Campari", ingredientName: "Campari", category: .liqueur),
            StarterBarItem(name: "Green Chartreuse", ingredientName: "Green Chartreuse", category: .liqueur),
            StarterBarItem(name: "Maraschino Luxardo", ingredientName: "Maraschino Liqueur", category: .liqueur),
            StarterBarItem(name: "Amaretto", ingredientName: "Amaretto", category: .liqueur),
            // Vermouth & Wine
            StarterBarItem(name: "Sweet Vermouth", ingredientName: "Sweet Vermouth", category: .vermouthWine),
            StarterBarItem(name: "Dry Vermouth", ingredientName: "Dry Vermouth", category: .vermouthWine),
            // Syrups & Bitters
            StarterBarItem(name: "Simple Syrup", ingredientName: "Simple Syrup", category: .syrup),
            StarterBarItem(name: "Honey Syrup", ingredientName: "Honey Syrup", category: .syrup),
            StarterBarItem(name: "Angostura Bitters", ingredientName: "Angostura Bitters", category: .bitter),
            StarterBarItem(name: "Orange Bitters", ingredientName: "Orange Bitters", category: .bitter),
            // Citrus
            StarterBarItem(name: "Lemons", ingredientName: "Lemon Juice", category: .juice),
            StarterBarItem(name: "Limes", ingredientName: "Lime Juice", category: .juice),
        ]
    )

    static let tikiBar = Template(
        id: "tiki-bar",
        name: "Tiki Bar",
        subtitle: "15 items for tropical cocktails",
        icon: "sun.max.fill",
        items: [
            StarterBarItem(name: "White Rum", ingredientName: "White Rum", category: .spirit),
            StarterBarItem(name: "Dark Rum", ingredientName: "Dark Rum", category: .spirit),
            StarterBarItem(name: "Aged Rum", ingredientName: "Aged Rum", category: .spirit),
            StarterBarItem(name: "Overproof Rum", ingredientName: "Overproof Rum", category: .spirit),
            StarterBarItem(name: "Orange Curaçao", ingredientName: "Orange Curaçao", category: .liqueur),
            StarterBarItem(name: "Falernum", ingredientName: "Falernum", category: .liqueur),
            StarterBarItem(name: "Orgeat", ingredientName: "Orgeat", category: .syrup),
            StarterBarItem(name: "Simple Syrup", ingredientName: "Simple Syrup", category: .syrup),
            StarterBarItem(name: "Grenadine", ingredientName: "Grenadine", category: .syrup),
            StarterBarItem(name: "Passion Fruit Syrup", ingredientName: "Passion Fruit Syrup", category: .syrup),
            StarterBarItem(name: "Limes", ingredientName: "Lime Juice", category: .juice),
            StarterBarItem(name: "Pineapple Juice", ingredientName: "Pineapple Juice", category: .juice),
            StarterBarItem(name: "Orange Juice", ingredientName: "Orange Juice", category: .juice),
            StarterBarItem(name: "Coconut Cream", ingredientName: "Coconut Cream", category: .mixer),
            StarterBarItem(name: "Angostura Bitters", ingredientName: "Angostura Bitters", category: .bitter),
        ]
    )
}
