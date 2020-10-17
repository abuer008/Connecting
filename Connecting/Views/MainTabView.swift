//
//  MainTabView.swift
//  Connecting
//
//  Created by bowei xiao on 23.09.20.
//

import SwiftUI
import SpriteKit

struct MainTabView: View {

    /// properties for `uiState changing`
    @ObservedObject var uiState: UIState = UIState()
    @ObservedObject var characterSettings: CharacterSettings = CharacterSettings()
    /// properties for `TabView`
    @State private var showFamilyView: Bool = true
    @State private var showSettingView: Bool = false

    // functions

    func pairButtonAction() {
        uiState.pairStateButton()
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
                Text("near by an other device")
                .multilineTextAlignment(.leading)
                .frame(width: 120)
            }
                    .offset(y: -150)
                    .foregroundColor(.white)

            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .frame(height: 400)
                            .foregroundColor(.white)

                    Text("Pairing a family connection")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                            .padding(.bottom, 240)
                            .onTapGesture {
                                uiState.pairStateButton()
                                characterSettings.addCharacter()
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
