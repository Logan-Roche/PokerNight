//
//  Database_Manager.swift
//  PokerNight
//
//  Created by Logan Roche on 2/26/25.
//

import Foundation
import FirebaseFirestore

class Database_Manager: ObservableObject {
    let db = Firestore.firestore()
    
    init() {
        loadData()
    }
    
    func loadData() {
        
        
    }
    
    
}

