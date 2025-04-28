import Foundation

struct LocalGame: Identifiable, Codable {
    var id: String
    var date: Date
    var title: String
    var host_id: String
    var sb_bb: String
    var is_active: Bool
    var chip_error_divided: Double
    var users: [String: User_Stats]
    var user_ids: [String]
    var transactions: [LocalTransaction]
    
    struct User_Stats: Codable {
        var name: String
        var buy_in: Double
        var buy_out: Double
        var net: Double
        var photo_url: String
    }
    
    struct LocalTransaction: Identifiable, Codable {
        var id: String  // Normal string here (no @DocumentID)
        var userId: String
        var name: String
        var type: String
        var amount: Double?
        var timestamp: Date
    }
}

extension LocalGame {
    init?(from game: Game) {
        guard let id = game.id else {
            print("Game missing ID, cannot convert to LocalGame.")
            return nil
        }
        
        self.id = id
        self.date = game.date
        self.title = game.title
        self.host_id = game.host_id
        self.sb_bb = game.sb_bb
        self.is_active = game.is_active
        self.chip_error_divided = game.chip_error_divided
        
        self.users = game.users.mapValues { userStats in
            LocalGame.User_Stats(
                name: userStats.name,
                buy_in: userStats.buy_in,
                buy_out: userStats.buy_out,
                net: userStats.net,
                photo_url: userStats.photo_url
            )
        }
        
        self.user_ids = game.user_ids
        
        self.transactions = game.transactions.compactMap { transaction in
            guard let id = transaction.id else { return nil }
            return LocalGame.LocalTransaction(
                id: id,
                userId: transaction.userId,
                name: transaction.name,
                type: transaction.type,
                amount: transaction.amount,
                timestamp: transaction.timestamp
            )
        }
    }
}
