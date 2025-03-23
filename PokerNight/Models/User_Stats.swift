import Foundation
import FirebaseFirestore

struct User_Stats: Codable {
    var name: String
    var buy_in: Double
    var buy_out: Double
    var net: Double
    var photo_url: String

    // Firestore decoding keys
    enum CodingKeys: String, CodingKey {
        case name, buy_in, buy_out, net, photo_url
    }
}
