import Foundation
import Observation

@Observable
final class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "favoriteCocktailIds"
    private(set) var favoriteIds: Set<String>

    private init() {
        let stored = UserDefaults.standard.stringArray(forKey: key) ?? []
        favoriteIds = Set(stored)
    }

    func toggle(_ id: String) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
        save()
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIds.contains(id)
    }

    var count: Int { favoriteIds.count }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIds), forKey: key)
    }
}
