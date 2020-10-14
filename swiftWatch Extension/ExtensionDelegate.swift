//
//  ExtensionDelegate.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 10.10.20.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    override init() {
        super.init()
//        WCSession.default.addObserver(self, forKeyPath: "activationState", options: [], context: nil)
//        WKExtension.shared().delegate = self
        _ = SharedConnectivity.shared
        print("extensionDelegate testing...")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("WCSession activation completed...")
        }
        
        if let e = error {
            print("\(#function): error for activation: \(e)")
        }
    }
    
    func applicationDidFinishLaunching() {
//        _ = SharedConnectivity.shared
    }
}
