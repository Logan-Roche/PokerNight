//
//  Database_Manager.swift
//  PokerNight
//
//  Created by Logan Roche on 2/26/25.
//

import Foundation
import FirebaseFirestore

class Database_Manager: ObservableObject {
    @Published private(set) var data: [temp] = []
    let db = Firestore.firestore()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("Temp").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!.localizedDescription)")
                return
            }

            print("Fetched \(documents.count) documents from Firestore.")

//            for document in documents {
//                print("Document ID: \(document.documentID)") // Print document ID
//                print("Raw Document Data: \(document.data())") // Print raw Firestore data
//            }

            self.data = documents.compactMap { document -> temp? in
                do {
                    let decodedData = try document.data(as: temp.self)
                    //print("Decoded document into temp: \(decodedData)")
                    return decodedData
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }

            //print("Updated data array: \(self.data)")
        }
    }

    
}

