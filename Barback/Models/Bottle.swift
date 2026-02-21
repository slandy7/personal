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
    var volumeML: Int = 750
    var abv: Double = 0
    var purchaseDate: Date?

    var category: BottleCategory {
        get { BottleCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var levelDescription: String {
        switch level {
        case 0.875...1.0: return "Full"
        case 0.625..<0.875: return "Three-quarters"
        case 0.375..<0.625: return "Half"
        case 0.01..<0.375: return "Low"
        case ...0: return "Empty"
        default: return "Full"
        }
    }

    var isLow: Bool { level < 0.25 && level > 0 }
    var isEmpty: Bool { level == 0 }

    var volumeDisplayString: String {
        if volumeML >= 1000 {
            let liters = Double(volumeML) / 1000.0
            return liters.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(liters))L"
                : String(format: "%.1fL", liters)
        }
        return "\(volumeML)ml"
    }

    var abvDisplayString: String? {
        guard abv > 0 else { return nil }
        return abv.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(abv))%"
            : String(format: "%.1f%%", abv)
    }

    init(
        name: String,
        ingredientName: String,
        category: BottleCategory,
        level: Double = 1.0,
        notes: String = "",
        isFavorite: Bool = false,
        volumeML: Int = 750,
        abv: Double = 0,
        purchaseDate: Date? = nil
    ) {
        self.name = name
        self.ingredientName = ingredientName
        self.categoryRaw = category.rawValue
        self.level = min(max(level, 0), 1)
        self.notes = notes
        self.dateAdded = Date()
        self.isFavorite = isFavorite
        self.volumeML = volumeML
        self.abv = min(max(abv, 0), 100)
        self.purchaseDate = purchaseDate
    }
}
