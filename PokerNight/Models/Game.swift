import Foundation
import FirebaseFirestore

// Game model representing the main game document
struct Game: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore document ID
    var date: Date
    var title: String
    //var total_buy_in: Double
    //var total_buy_out: Double
    //var player_count: Int
    var host_id: String
    var sb_bb: String
    var is_active: Bool
    var chip_error_divided: Double
    var users: [String: User_Stats]  // Dictionary of user stats
    var user_ids: [String] = []
    var transactions: [Transaction] = []  // List of transaction objects

    // Nested struct for user stats
    struct User_Stats: Codable {
        var name: String
        var buy_in: Double
        var buy_out: Double
        var net: Double
        var photo_url: String
    }
    
    // Firestore decoding keys
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        //case total_buy_in
        //case total_buy_out
        //case player_count
        case host_id
        case sb_bb
        case is_active
        case chip_error_divided
        case users
        case user_ids
        case transactions
    }
}
