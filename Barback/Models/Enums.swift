import Foundation
import SwiftUI

// MARK: - Bottle Category (for inventory grouping)

enum BottleCategory: String, Codable, CaseIterable, Identifiable {
    case spirit = "Spirits"
    case liqueur = "Liqueurs & Amari"
    case vermouthWine = "Vermouth & Wine"
    case syrup = "Syrups"
    case juice = "Juices"
    case mixer = "Mixers"
    case bitter = "Bitters"
    case garnish = "Garnishes & Other"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .spirit: return "flame.fill"
        case .liqueur: return "drop.fill"
        case .vermouthWine: return "wineglass.fill"
        case .syrup: return "drop.halffull"
        case .juice: return "leaf.fill"
        case .mixer: return "bubbles.and.sparkles"
        case .bitter: return "paintbrush.pointed.fill"
        case .garnish: return "laurel.leading"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .spirit: return Color(red: 0.80, green: 0.52, blue: 0.20)    // warm amber-orange
        case .liqueur: return Color(red: 0.58, green: 0.27, blue: 0.42)   // warm plum
        case .vermouthWine: return Color(red: 0.68, green: 0.22, blue: 0.26) // wine red
        case .syrup: return Color(red: 0.76, green: 0.58, blue: 0.28)     // honey
        case .juice: return Color(red: 0.40, green: 0.56, blue: 0.32)     // sage green
        case .mixer: return Color(red: 0.30, green: 0.52, blue: 0.52)     // warm teal
        case .bitter: return Color(red: 0.70, green: 0.38, blue: 0.28)    // terra cotta
        case .garnish: return Color(red: 0.48, green: 0.54, blue: 0.30)   // olive green
        case .other: return Color(red: 0.52, green: 0.48, blue: 0.44)     // warm gray
        }
    }
}

// MARK: - Cocktail Category (by base spirit)

enum CocktailCategory: String, Codable, CaseIterable, Identifiable {
    case whiskey = "Whiskey"
    case gin = "Gin"
    case rum = "Rum"
    case tequila = "Tequila & Mezcal"
    case vodka = "Vodka"
    case brandy = "Brandy & Wine"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .whiskey: return "flame"
        case .gin: return "leaf"
        case .rum: return "sun.max"
        case .tequila: return "sparkle"
        case .vodka: return "snowflake"
        case .brandy: return "wineglass"
        case .other: return "star"
        }
    }

    var color: Color {
        switch self {
        case .whiskey: return Color(red: 0.75, green: 0.48, blue: 0.18)   // rich amber
        case .gin: return Color(red: 0.35, green: 0.55, blue: 0.40)       // botanical green
        case .rum: return Color(red: 0.65, green: 0.40, blue: 0.22)       // warm copper
        case .tequila: return Color(red: 0.72, green: 0.60, blue: 0.20)   // warm gold
        case .vodka: return Color(red: 0.42, green: 0.48, blue: 0.55)     // cool slate
        case .brandy: return Color(red: 0.55, green: 0.25, blue: 0.30)    // burgundy
        case .other: return Color(red: 0.52, green: 0.48, blue: 0.44)     // warm gray
        }
    }
}

// MARK: - Glass Type

enum GlassType: String, Codable, CaseIterable, Identifiable {
    case rocks = "Rocks"
    case coupe = "Coupe"
    case martini = "Martini"
    case highball = "Highball"
    case collins = "Collins"
    case flute = "Flute"
    case hurricane = "Hurricane"
    case copperMug = "Copper Mug"
    case tiki = "Tiki Mug"
    case wineGlass = "Wine Glass"
    case irishCoffee = "Irish Coffee Glass"
    case nickAndNora = "Nick & Nora"
    case snifter = "Snifter"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .rocks: return "square.fill"
        case .coupe, .nickAndNora: return "v.circle.fill"
        case .martini: return "triangle.fill"
        case .highball, .collins: return "rectangle.portrait.fill"
        case .flute: return "rectangle.fill"
        case .hurricane, .tiki: return "trophy.fill"
        case .copperMug: return "mug.fill"
        case .wineGlass: return "wineglass.fill"
        case .irishCoffee: return "cup.and.saucer.fill"
        case .snifter: return "circle.fill"
        }
    }
}

// MARK: - Difficulty

enum CocktailDifficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case advanced = "Advanced"
}
