//
// Created by bowei xiao on 10.10.20.
//

import WatchConnectivity

class SharedConnectivity: NSObject {
  
  static let shared = SharedConnectivity()
  
  weak var delegate: TouchHandleDelegate?
  
  private override init() {
    super.init()
    
    assert(WCSession.isSupported(), "current device do not support watch connectivity")
    WCSession.default.delegate = self
    WCSession.default.activate()
  }
  
  func sendTouchData(touchData: TouchModel) -> [String: Any] {
    let touchDuration: Double = touchData.duration
    let touchTime: Date = touchData.timeStampe
    
    let payLoad = touchData.message
    
    let userInfo: [String: Any] = ["TouchDuration": touchDuration, "TouchTime": touchTime]
    
    WCSession.default.sendMessage(payLoad) { (replyMessage) in
      print("\(#function): replyMessaging \(replyMessage)")
    } errorHandler: { (error) in
      print("\(#function): fail to send message")
    }
    return userInfo
  }
  
  
}

extension SharedConnectivity: WCSessionDelegate {
    
  
  
  #if os(iOS)
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("\(#function): activeState = \(session.activationState.rawValue)")
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }
  
  func sessionWatchStateDidChange(_ session: WCSession) {
    print("\(#function): activeState = \(session.activationState.rawValue)")
  }
  
  #endif
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let e = error {
      print("\(#function): activation did not completing...\(e)")
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
    let userInfo = message
    // do some thing when receiving data
    #if os(watchOS)
    print("\(#function): watch receiving data...\(userInfo)")
    // implemente function in watch platform
    #else
    print("\(#function): moblie receiving data...\(userInfo)")
    // implementate function in ios platform
//    guard let touchDuration:Double = userInfo["TouchDuration"] as? Double else {
//      print("wrong input")
//      return
//    }
    delegate?.handleTouch(self, message: userInfo["TouchDuration"] as! Double)
    #endif
    replyHandler(message)
    return
  }
}
