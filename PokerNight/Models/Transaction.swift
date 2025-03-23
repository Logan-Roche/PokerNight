import Foundation
import FirebaseFirestore

// Transaction model for individual game transactions
struct Transaction: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore document ID
    var userId: String
    var name: String // user's display name
    var type: Int  //
    var amount: Double?
    var timestamp: Date


    // Firestore decoding keys
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case name
        case type
        case amount
        case timestamp
    }
}
