import Foundation
import SwiftData

@Model
final class Bottle {
    var name: String = ""
    var ingredientName: String = ""
    var categoryRaw: String = "Other"
    var level: Double = 1.0
    var notes: String = ""
    var dateAdded: Date = Date()
    var isFavorite: Bool = false

    var category: BottleCategory {
        get { BottleCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var levelDescription: String {
        switch level {
        case 0.75...1.0: return "Full"
        case 0.5..<0.75: return "Three-quarters"
        case 0.25..<0.5: return "Half"
        case 0.01..<0.25: return "Low"
        case 0: return "Empty"
        default: return "Full"
        }
    }

    var isLow: Bool { level < 0.25 && level > 0 }
    var isEmpty: Bool { level == 0 }

    init(
        name: String,
        ingredientName: String,
        category: BottleCategory,
        level: Double = 1.0,
        notes: String = "",
        isFavorite: Bool = false
    ) {
        self.name = name
        self.ingredientName = ingredientName
        self.categoryRaw = category.rawValue
        self.level = level
        self.notes = notes
        self.dateAdded = Date()
        self.isFavorite = isFavorite
    }
}
