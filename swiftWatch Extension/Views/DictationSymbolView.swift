//
//  DictationSymbolView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI
import SpriteKit
import WatchKit

struct DictationSymbolView: View {
    
    @State private var recording:Bool = false
    
    @Binding var showDictation:Bool
    
    var recordingScene:SKScene {
        let scene = SKScene(fileNamed: "Recording")
        scene?.size = CGSize(width: 100, height: 60)
        scene?.backgroundColor = .clear
        return scene!
    }
    
    var body: some View {
        
        ZStack {
            Image(systemName: "mic.fill")
                .foregroundColor(recording ? .accentColor : Color.secondary.opacity(0.6))
                .font(.system(size: 35))
                .frame(width: recording ? 120 : 60, height: 60, alignment: .center)
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            
            if recording {
                    SpriteView(scene: recordingScene)
                        .frame(width: 70, height: 40, alignment: .center)
                        .offset(y: -35)
                        .transition(.opacity)
                        .edgesIgnoringSafeArea(.top)
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                self.showDictation = self.recording ? false : true
                UserDefaults.standard.setValue(self.showDictation, forKey: "ShowDictation")
                WKInterfaceDevice.current().play(self.showDictation ? .click : .start)
                self.recording = true
            }
    }
    }
}

struct DictationSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        DictationSymbolView(showDictation: .constant(false))
    }
}
