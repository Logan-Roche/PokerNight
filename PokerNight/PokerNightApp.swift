//
//  PokerNightApp.swift
//  PokerNight
//
//  Created by Logan Roche on 2/23/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start(completionHandler: nil)
        
        return true
    }
}

@main
struct PokerNightApp: App {
    @StateObject private var game_view_model = Games_View_Model()  // Shared instance
    @StateObject private var auth_view_model = Authentication_View_Model()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var interstitial_ad_manager = InterstitialAdsManager()
    
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
                Authenticated_View {
                } content: {
                    ContentView()
                        .environmentObject(
                            game_view_model
                        )  // Inject into environment
                        .environmentObject(auth_view_model)
                        .environmentObject(interstitial_ad_manager)
                        .onChange(of: scenePhase) { oldPhase, newPhase in
                                    if newPhase == .active {
                                        if let user = Auth.auth().currentUser {
                                            print("📶 App in foreground — start listener")
                                            game_view_model.startListeningForCurrentGame(userID: user.uid)
                                        }
                                    } else if newPhase == .background || newPhase == .inactive {
                                        print("🔕 App in background — stop listener")
                                        game_view_model.stopListening()
                                    }
                                }
                }
//            }
          
        }
    }
}
