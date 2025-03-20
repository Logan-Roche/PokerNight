import Foundation
import FirebaseFirestore

struct User_Stats: Codable {
    var buy_in: Double
    var buy_out: Double
    var net: Double

    // Firestore decoding keys
    enum CodingKeys: String, CodingKey {
        case buy_in, buy_out, net
    }
}
