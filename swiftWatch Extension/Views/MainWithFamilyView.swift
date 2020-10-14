//
//  MainWithFamilyView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI
import SpriteKit
import WatchKit

struct MainWithFamilyView: View {
    
    @State var activeStatisticView:Bool = false
    @State var showDictation:Bool = false
    
    
    // Scenes
    var heartScene:SKScene {
        let heart = SKScene(fileNamed: "HeartShape")
        heart?.backgroundColor = .clear
        return heart!
    }
    
    var body: some View {
        ZStack {
            
            if activeStatisticView {
                GlobalStatisticView()
                    
            }
            
            ContentView(showDictation: $showDictation)
                .offset(y: activeStatisticView ? 63 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        WKInterfaceDevice.current().play(.click)
                        self.showDictation.toggle()
                    }
                }
            
            VStack {
                HStack {
                    SpriteView(scene: heartScene)
                        .frame(width: 45, height: 45, alignment: .center)
                        .padding(.top, 25)
                        .padding(.horizontal, 5)
                        .offset(y: showDictation ? -40 : 0)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.activeStatisticView.toggle()
                            }
                            WKInterfaceDevice.current().play(.click)
                        }
                    Spacer()
                }
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.all)
            
            if showDictation {
                HStack {
                    VStack {
                        DictationSymbolView(showDictation: $showDictation)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    Spacer()
                }
                .transition(.opacity)
            }
        }
    }
}

struct MainWithFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        MainWithFamilyView()
    }
}
