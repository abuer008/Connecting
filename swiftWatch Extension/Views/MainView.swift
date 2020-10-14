//
//  MainView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI
import SpriteKit
import WatchKit

struct MainView: View {
    
    @State var isConnecting:Bool = false
    @State var isPairing:Bool = false
    
    @State var activeStatisticView:Bool = false
    @State var showDictation:Bool = false
    
    @State var watchTouch:Bool = false
    
    @State var gestureValue:CGSize = .zero
    
    // Scenes
    var heartScene:SKScene {
        let heart = SKScene(fileNamed: "HeartShape")
        heart?.backgroundColor = .clear
        return heart!
    }
    var arrowScene:SKScene {
        let arrow = SKScene(fileNamed: "ArrowScene")
        arrow?.backgroundColor = .clear
        return arrow!
    }
    
    private func pairingAction() {
        /// state 1. before tap pairing button, `isPairing = false` and `isConnecting = false`
        /// play blink anima
        
        /// state 2. tapped pairing button, `isPairing = true` and `isConnecting = false`
        /// play pair searching anima
        withAnimation(.easeInOut(duration: 1)) {
            self.isPairing = true
        }
        
        UserDefaults.standard.setValue(self.isPairing, forKey: "PairingState")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            
            /// state 3. 3 seconds later, `isPairing = true` and `isConnecting = true`
            /// play success anima
            
            withAnimation(.easeInOut(duration: 1)){
                self.isConnecting = true
            }
            
            UserDefaults.standard.setValue(self.isConnecting, forKey: "ConnectState")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                WKInterfaceDevice.current().play(.success)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                /// state 4. `isPairing = false` and `isConnecting = true`
                /// enter auto anima
                withAnimation(.easeInOut(duration: 1)) {
                    self.isPairing = false
                }
                
                UserDefaults.standard.setValue(self.isPairing, forKey: "PairingState")
            }
        }
    }
    
    var body: some View {
        ZStack {
            // debugging for state control
            
            //            VStack {
            //                HStack {
            //                    Image(systemName: isPairing ? "plus.circle.fill" : "minus.circle")
            //                        .foregroundColor(.red)
            //                    Spacer()
            //                    Image(systemName: isConnecting ? "plus.circle.fill" : "minus.circle")
            //                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            //                }
            //                .font(.title)
            //                .padding(.horizontal, 10)
            //                .padding(.top, 40)
            //                Spacer()
            //            }
            
            // debugging for swipe gesture
            
            //            VStack {
            //                Text("gestureWidth: \(gestureValue.width)")
            //                Text("gestureHeight: \(gestureValue.height)")
            //            }
            
            if activeStatisticView {
                GlobalStatisticView()
                    .transition(.opacity)
            }
            
            ZStack {
                
                VStack {
                    if !isPairing && !isConnecting {
                        Text("Tap button for pairing person in near range.")
                            .transition(.opacity)
                    } else if isPairing && !isConnecting {
                        Text("Searching...")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                
                ContentView(showDictation: $showDictation)
                //                    .gesture(DragGesture()
                //                                .onChanged({ (value) in
                //
                //                                })
                //                                .onEnded({ (value) in
                //                                }))
                VStack {
                    Spacer()
                    HStack {
                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                            .frame(width: 4, height: 2.5, alignment: .center)
                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                            .frame(width: 5, height: 2.5, alignment: .center)
                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                            .frame(width: 120, height: 2.5, alignment: .center)
                    }
                    .foregroundColor(.accentColor)
                    .opacity(0.6)
                    .padding(.bottom, 23)
                }
                .opacity(isConnecting ? 1.0 : 0.0)
                .animation(.interactiveSpring())
                
                VStack {
                    Spacer()
                    Text("Lorenz")
                        .opacity(isConnecting && !isPairing ? 1.0 : 0.0)
                        .gesture(DragGesture()
                                    .onChanged({ (value) in
                                        self.gestureValue = value.translation
                                    })
                                    .onEnded({ (value) in
                                        if value.translation.height <= -50 {
                                            guard self.activeStatisticView != true else { return }
                                            
                                            withAnimation(.spring()) {
                                                WKInterfaceDevice.current().play(.click)
                                                self.showDictation = true
                                            }
                                            UserDefaults.standard.setValue(showDictation, forKey: "ShowDictation")
                                        }
                                    })
                        )
                }
            }
            .offset(y: activeStatisticView ? 63 : 0)
            .edgesIgnoringSafeArea(.all)
            //            .gesture(DragGesture()
            //                        .onChanged({ (_) in
            //                            watchTouch = true
            //                            print("Touching...")
            //                            UserDefaults.standard.setValue(true, forKey: "WatchTouch")
            //                        })
            //                        .onEnded({ (_) in
            //                            watchTouch = false
            //                            print("Finishing...")
            //                            UserDefaults.standard.setValue(false, forKey: "WatchTouch")
            //                        }))
            
            VStack {
                HStack {
                    if !isPairing && isConnecting {
                        SpriteView(scene: heartScene)
                            .frame(width: 45, height: 45, alignment: .center)
                            .padding(.top, 25)
                            .padding(.horizontal, 5)
                            .offset(y: showDictation ? -40 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 1)) {
                                    self.activeStatisticView.toggle()
                                }
                                UserDefaults.standard.setValue(self.activeStatisticView, forKey: "ActiveStatistic")
                                
                                WKInterfaceDevice.current().play(.click)
                            }
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
            
            //            if !(isPairing && isConnecting) && !(!isPairing && isConnecting) {
            BackStageView()
                .offset(y: isConnecting ? 38 : 0)
                .blur(radius: isConnecting ? 10 : 0)
                .opacity(isConnecting ? 0 : 1)
                .edgesIgnoringSafeArea(.all)
            //            }
            
            VStack {
                Spacer()
                
                if !(!isPairing && isConnecting) {
                    Button(action: pairingAction, label: {
                        Text("Pairing")
                    })
                    .offset(y: isConnecting && isPairing ? 70 : 0)
                    .blur(radius: isConnecting ? 10 : 0)
                    .padding(.bottom, 15)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            
        }
//        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // ensure dictation anima do not play at start
            UserDefaults.standard.setValue(false, forKey: "ShowDictation")
            
            // check if already have a connecting
//            guard UserDefaults.standard.bool(forKey: "ConnectState") == false  else {
//                return
//            }
            
            // force to set false if no connecting
            UserDefaults.standard.setValue(isConnecting, forKey: "ConnectState")
            UserDefaults.standard.setValue(isPairing, forKey: "PairingState")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct BackStageView: View {
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Color.black
                Rectangle()
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .foregroundColor(.accentColor)
//                    .opacity(0.6)
                    .scaleEffect(1.05)
                    .frame(width: 120, height: 2, alignment: .center)
                    .padding(.bottom, 65)
            }
            .frame(width: 120, height: 60, alignment: .center)
        }
    }
}
