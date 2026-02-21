import Foundation
import SwiftData

@Model
final class CocktailLog {
    var cocktailId: String = ""
    var dateMade: Date = Date()
    var rating: Int = 0
    var notes: String = ""

    init(cocktailId: String, rating: Int = 0, notes: String = "") {
        self.cocktailId = cocktailId
        self.dateMade = Date()
        self.rating = rating
        self.notes = notes
    }
}
