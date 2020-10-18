//
//  MyCharacterCardView.swift
//  Connecting
//
//  Created by bowei xiao on 23.09.20.
//

import SwiftUI
import SpriteKit

struct MyCharacterCardView: View {
    @Binding var character:Character
    
    var body: some View {
            SpriteView(scene: character.scene, options: .allowsTransparency)
                
                // Character color setting
                .frame(height: 303, alignment: .top)
                .hueRotation(Angle(degrees: character.characterColor.0))
                .saturation(character.characterColor.1)
                    .scaleEffect(0.9)
                
                // posisition and size of character
                .offset(x: 60, y: 35)
                
                // background color setting
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(character.backgroundColor[0]), Color(character.backgroundColor[1])]), startPoint: .top, endPoint: .bottom).opacity(0.5))
                
                // Card shape
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                // position of Card
//                .offset(x: 0, y: -235)
                .shadow(color: Color(character.backgroundColor[1]).opacity(0.7), radius: 15, x: 0.0, y: 15.0)
                .edgesIgnoringSafeArea(.all)
        
    }
}

struct MyCharacterCardView_Previews: PreviewProvider {
    static var previews: some View {
        MyCharacterCardView(character: .constant(mockCharacters[1]))
    }
}
