//
//  MainTabView.swift
//  Connecting
//
//  Created by bowei xiao on 23.09.20.
//

import SwiftUI
import SpriteKit

struct MainTabView: View {
    @Namespace private var initialise
    /// properties for `uiState changing`
    @ObservedObject var uiState: UIState = UIState()
    @EnvironmentObject var characterSettings: CharacterSettings
    /// properties for `TabView`
    @State private var showFamilyView: Bool = true
    @State private var showSettingView: Bool = false

    /// Properties for PairView
    ///
    /// state changes:
    /// - isPair false, isConnect false = .pending
    /// - isPair true, isConnect false = .pair
    /// - isPair true, isConnect true = .success
    /// - isPair false, isConnect true = .idle

    @State private var isPair: Bool = false
    @State private var isConnect: Bool = false

    // functions

    func pairButtonAction() {
//        uiState.pairStateButton()
        withAnimation(.spring()) {
            characterSettings.addCharacter()
        }
    }

    @ViewBuilder
    var body: some View {
        if characterSettings.characterSettings != [] {
            mainCard
        } else {
            pairView
        }
    }

    // TODO: build the startup view
    //  - Set the state for pending, searching, success, active

    var pairView: some View {
        ZStack {

            SpriteView(scene: PrototypeScene(), options: .allowsTransparency)
                    .offset(y: -115)
                    .scaleEffect(0.5)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("orangeIdleTop"), Color("orangeIdleBottom")]), startPoint: .top, endPoint: .bottom))

            HStack {
                Image(systemName: "applewatch.radiowaves.left.and.right")
                        .font(.system(size: 45, weight: .thin, design: .default))
                        // debugging
                        .onTapGesture {
                            uiState.pairStateButton(requestedState: .pending)
                        }
                Text("Please near by an other device")
                        .multilineTextAlignment(.leading)
                        .frame(width: 120)
            }
                    .opacity(isPair || isConnect ? 0 : 1)
                    .offset(y: -150)
                    .foregroundColor(.white)

            VStack {
                Spacer()
                ZStack {
                    if !isPair && isConnect {
                        GeometryReader { bounds in
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .matchedGeometryEffect(id: "ForeGround", in: initialise, isSource: !isPair && isConnect)
                                    .foregroundColor(.white)
                                    .offset(y: bounds.frame(in: .global).height)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .matchedGeometryEffect(id: "ForeGround", in: initialise)
                                .frame(height: 400)
                                .foregroundColor(.white)
                    }

                    if isPair {
                        Text("Seaching...")
                                .font(.title)
                                .bold()
                                .foregroundColor(.secondary)
                                .matchedGeometryEffect(id: "TextButton", in: initialise)
                                .padding(.bottom, 200)

                    } else if isConnect {

                    } else {
                        Text("Pairing a family connection")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .matchedGeometryEffect(id: "TextButton", in: initialise)
                                .frame(width: 300)
                                .padding(.bottom, 200)
                                .transition(.opacity)
                                .onTapGesture {
                                    uiState.pairStateButton(requestedState: .pair)
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        self.isPair = true
                                        self.isConnect = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        uiState.pairStateButton(requestedState: .success)
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            self.isPair = false
                                            self.isConnect = true
                                            self.characterSettings.addCharacter()
                                        }
                                    }
                                }
                    }
                }
            }
        }
                .edgesIgnoringSafeArea(.all)
    }

    var mainCard: some View {
        ZStack {

            TabView {
                mainWithFamily()
                        .tabItem {
                            Image(systemName: "rectangle.stack.person.crop.fill")
                            Text("My Family")
                        }
                MyCharacterView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("My Character")
                        }

            }

            // Pair Button
            ZStack {
                Button(action: pairButtonAction, label: {
                    Image(systemName: "paperclip")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80, alignment: .center)
                            .background(Color("orangeIdleBottom"))
                            .clipShape(Circle())
                            .shadow(color: Color("orangeIdleBottom"), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 5)
                })
            }
                    .offset(y: 320)

        }
    }
}

class MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView().environmentObject(CharacterSettings())
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: MainTabView())
    }
    #endif
}

struct TabButton: View {
    var imageName: String
    var textName: String
    var color: Color

    var body: some View {
        VStack {
            Image(systemName: imageName)
                    .font(.title2)
                    .foregroundColor(color)
        }.offset(y: 5)
    }
}
