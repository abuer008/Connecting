//
//  ConnectingApp.swift
//  Connecting
//
//  Created by bowei xiao on 04.08.20.
//

import SwiftUI
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = SharedConnectivity.shared
        return true
    }
}

@main
struct ConnectingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var characterSet = CharacterSettings()
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(characterSet)
        }
    }
}
