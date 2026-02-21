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
        case .spirit: return .orange
        case .liqueur: return .purple
        case .vermouthWine: return .red
        case .syrup: return .brown
        case .juice: return .green
        case .mixer: return .cyan
        case .bitter: return .mint
        case .garnish: return .teal
        case .other: return .gray
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
        case .whiskey: return .orange
        case .gin: return .green
        case .rum: return .brown
        case .tequila: return .yellow
        case .vodka: return .blue
        case .brandy: return .purple
        case .other: return .gray
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
