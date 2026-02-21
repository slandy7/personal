import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String = ""
    var categoryRaw: String = "Other"
    var isCompleted: Bool = false
    var notes: String = ""
    var dateAdded: Date = Date()

    var category: BottleCategory {
        get { BottleCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    init(
        name: String,
        category: BottleCategory = .other,
        notes: String = ""
    ) {
        self.name = name
        self.categoryRaw = category.rawValue
        self.notes = notes
        self.dateAdded = Date()
        self.isCompleted = false
    }
}
