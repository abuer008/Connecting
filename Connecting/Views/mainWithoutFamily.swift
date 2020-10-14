//
//  ContentView.swift
//  Connecting
//
//  Created by bowei xiao on 04.08.20.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var body: some View {
        ZStack {
            PairingView()
                
            
            VStack {
                HStack {
                    Text("My Family")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.top, 20)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PairingView: View {
    @State var pairingFamily = false
    
    
    var body: some View {
        ZStack {
            
            // orange gradient background
            VStack {
                ZStack {
                    
                    LinearGradient(gradient: Gradient(colors: [Color("orangeBackground2"), Color("orangeBackground1")]), startPoint: .bottom, endPoint: .top)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 380)
                    
                    HStack {
                        
                        Image(systemName: "applewatch.radiowaves.left.and.right")
                            .font(.system(size: 60, weight: .thin))
                            .foregroundColor(.white)
                        Text("please near by another family device.")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 70)
                    .padding(.top, 50)
                    
                }
                
                    
                Spacer()
            }
            
            if pairingFamily {
//                LottieView(fileName: "sideMove", fromFrame: 0, toFrame: 717)
//                    .frame(width: 250)
//                    .offset(y: -100)
//                    .blur(radius: 0.4)
            }
            
            // white gradient bottom
            VStack {
                Spacer()
                
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 200)
                    .frame(height: 420, alignment: .bottom)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }.edgesIgnoringSafeArea(.bottom)
            
            // button for pairing
            Text("Pairing a family connection")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(pairingFamily ? Color.secondary : Color.black)
                .multilineTextAlignment(.center)
                .frame(width: 201)
                .frame(width: 253, height: 87)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
//                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                .padding(.top, 150)
                .onTapGesture {
                    withAnimation(.spring()) {
                        self.pairingFamily.toggle()
                    }
                }
        }
    }
}
