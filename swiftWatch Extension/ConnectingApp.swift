//
//  ConnectingApp.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.08.20.
//

import SwiftUI

@main
struct ConnectingApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}
