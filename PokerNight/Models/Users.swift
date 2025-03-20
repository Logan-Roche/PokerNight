import Foundation
import FirebaseFirestore

// User model for Firestore
struct Users: Identifiable, Codable {
    @DocumentID var id: String?   // Firestore document ID (same as Firebase Auth ID)
    var name: String
    var email: String
    var profile_photo_url: String?
    
    var net: Double
    
    // Firestore decoding keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case profile_photo_url
        case net
    }
}
