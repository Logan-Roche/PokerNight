import Foundation

struct User_Model: Identifiable, Codable {
    var id: String              // Firestore document ID (same as Firebase Auth UID)
    var email: String
    var displayName: String?
    var photoURL: String?
    //var totalBuyIns: Double
    //var gamesPlayed: Int
    var current_game: String?
}
