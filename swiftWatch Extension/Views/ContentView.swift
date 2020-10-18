//
//  ContentView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.08.20.
//

import SwiftUI
import SpriteKit
import WatchKit
import WatchConnectivity

struct ContentView: View {
  
  // variables
  
  /// color set 1. `original blue` 2. `purple` 3. `red`
  
  private let characterColorSet = [(0.0, 1.0), (225.0, 1.5), (190.0, 1.7)]
  
  @Binding var showDictation: Bool
  
  @State var hiddenTouchScene: Bool = true
  
  @State var colorSetting: (Double, Double) = (0.0, 1.0)
  
  // debug
  @State var heartRate: Int = 0
  @State var isTap = false
  
  let healthKitData = HealthKitData()
//    let connecting = SharedConnectivity()
  
  // Scenes
  var characterScene = GameScene()
  var touchScene = TouchScene()
  
  var body: some View {
    ZStack {
      hiddenTouchScene ?
              SpriteView(scene: characterScene)
              :
              SpriteView(scene: touchScene)
    }
            .hueRotation(Angle(degrees: colorSetting.0))
            .saturation(colorSetting.1)
            .animation(.spring(response: 0.5, dampingFraction: 0.5))
            .gesture(DragGesture()
                    .onChanged({ (value) in
                      // cancelling the dictation when touch the character
                      if self.showDictation {
                        withAnimation(.spring()) {
                          self.showDictation = false
                        }
                        WKInterfaceDevice.current().play(.click)
                        UserDefaults.standard.setValue(self.showDictation, forKey: "ShowDictation")
                      }
                      // hidden auto anima
                      withAnimation(.linear(duration: 0.3)) {
                        hiddenTouchScene = false
                      }
                      
                      // haptic feedback
                      if value.translation.height < 0 && value.translation.width > -65 {
                        // swipe up
                        
                        WKInterfaceDevice.current().play(.click)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                          WKInterfaceDevice.current().play(.click)
                        }
                      }
                      
                      if value.translation.height > 0 && value.translation.width < 65 {
                        // swipe down
                        WKInterfaceDevice.current().play(.click)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                          WKInterfaceDevice.current().play(.click)
                        }
                      }
                      
                      if value.translation.width <= -65 {
                        // swipe left
                        print("swipe left")
                      }
                      
                      if value.translation.width >= 65 {
                        // swipe right
                        print("swipe right")
                      }
                    })
                    .onEnded({ (value) in
                      let touchData = TouchModel(duration: 1.1, timeStampe: value.time)
                      WCSession.default.sendMessage(touchData.message, replyHandler: { replyMessage in
                        print("\(#function): \(replyMessage)")
                      })
//                        SharedConnectivity.shared.sendTouchData(touchData: touchData)
                      withAnimation(.linear(duration: 0.3)) {
                        hiddenTouchScene = true
                      }
                    })
            )
            .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(showDictation: .constant(false))
  }
}
