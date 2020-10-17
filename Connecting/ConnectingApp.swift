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
        #if DEBUG
        var injectionBundlePath = "/Applications/InjectionIII.app/Contents/Resources"
        #if targetEnvironment(macCatalyst)
        injectionBundlePath = "\(injectionBundlePath)/macOSInjection.bundle"
        #elseif os(iOS)
        injectionBundlePath = "\(injectionBundlePath)/iOSInjection.bundle"
        #endif
        Bundle(path:injectionBundlePath)?.load()
        #endif
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
