//
//  AuthenticationApp.swift
//  Authentication
//
//  Created by Utsav busa on 12/04/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct AuthenticationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var viewModel = AuthenticationViewModel()
//
//    init() {
//       setupAuthentication()
//     }
    var body: some Scene {
        WindowGroup {
          
           
                RootView()
        
        }
    }
}
//extension AuthenticationApp {
//  private func setupAuthentication() {
//    FirebaseApp.configure()
//  }
//}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
      
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//        return .noData
//    }
}
