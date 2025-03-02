//
//  Finance.swift
//  PokerNight
//
//  Created by Logan Roche on 2/27/25.
//

import Foundation
import FinanceKit
import SwiftUICore



//class Finance {
//    // Remove the async call from the property initializer
//    public let store: FinanceStore
//    var account: [Account] = []
//    
//    // Asynchronous initialization
//    public init() {
//        self.store = FinanceStore.shared  // Sync initialization
//        self.account = []        // Default value
//        
//        Task {
//            // Perform the async operation inside a Task
//            await loadData()
//        }
//    }
//    
//    // The async method to load data
//    func loadData() async {
//        do {
//            let accountQuery = AccountQuery(sortDescriptors: [], predicate: nil, limit: nil, offset: nil)
//            let fetched_account = try await FinanceStore.shared.accounts(query: accountQuery);
//            self.account = fetched_account
//        }
//        catch {
//            print("Error fetching account: \(error)")
//        }
//    }
//}


public class Finance {
    public let store: FinanceStore
    
    
    public init(){
        self.store = FinanceStore.shared
        
        Task {
            await loadData()
        }
        
    }
    
    func loadData() async {
        do {
            var avaibility = FinanceStore.isDataAvailable(.financialData)
            var finace_authorizaiton = try await store.authorizationStatus()
        }
        catch {
            print("Error authroizing: \(error)")
        }
    }
    
}
    



    



