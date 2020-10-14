//
//  MyCharacterView.swift
//  Connecting
//
//  Created by bowei xiao on 15.09.20.
//

import SwiftUI

struct MyCharacterView: View {
    
    @State var character:Character = mockCharacters[0]
    
    @State private var showQuoteInput:Bool = false
    
    var body: some View {
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                    Rectangle()
                        .frame(width: 0, height: 250, alignment: .center)
                        .foregroundColor(Color.white.opacity(0))
                    MyCharacterSettingView()
                    
                    Rectangle()
                        .foregroundColor(Color("blueSleepyTop"))
                        .frame(width: 300, height: 120, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.bottom, 70)
            }
//            .background(Color.white)
            
            
            ZStack {
                VStack {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .frame(width: .infinity, height: 303, alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
//                    .offset(y: -235)
                VStack {
                    MyCharacterCardView(character: $character)
                    Spacer()
                }
            }
            
            VStack(alignment: .trailing) {
                HStack {
                    TextField("Enter your name", text: $character.name)
                        .font(.headline)
                        .frame(width: 131, height: 30, alignment: .leading)
                        .padding(.horizontal, 7)
                        .border(Color.black.opacity(0.1), width: 2)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    Spacer()
                }
//                .padding(.top, 100)
                
                HStack {
                    Button(action: {
                        showQuoteInput = true
                    }, label: {
                        Text("Edit quote")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 115, height: 40, alignment: .center)
                            .background(Color(character.backgroundColor[1]))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(character.backgroundColor[1]), radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    })
                    .sheet(isPresented: $showQuoteInput, onDismiss: {
                        // do something when dismiss
                    }, content: {
                        QuoteTextInputView()
                    })
                    .padding(.vertical)
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top, 120)
            .padding(.horizontal, 40)
            
            VStack {
                HStack {
                    Text("My Character")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal, 60)
                Spacer()
            }
            .padding(.top, 60)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MyCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        MyCharacterView()
    }
}
