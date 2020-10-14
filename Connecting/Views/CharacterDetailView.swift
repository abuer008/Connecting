//
//  CharacterDetailView.swift
//  Connecting
//
//  Created by bowei xiao on 17.09.20.
//

import SwiftUI
import SpriteKit

struct CharacterDetailView: View {
    
    @Namespace var namespace
    
    /// properties for `CharacterDetailView`
//    @State private var isSingleCardBeenActived:Bool = true
//    @State private var activeIndex:Int = -1
//    @State private var radius:CGFloat = 20
//    var index:Int = 0
//    @State private var showDetail:Bool = true
//    @State private var scaleParm:CGFloat = 1.0
//    @State private var isListState:Bool = false
    @Binding var character:Character
    
    var body: some View {
        
        VStack {
            ZStack {
                HStack {
                    VStack {
                        Text(character.stateName[.Idle]! + " placeholder")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 220)
                            .padding(.leading, 220)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .frame(width: .infinity, height: 303, alignment: .top)
            //            .padding(.bottom, -10)
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10, pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/, content: {
                    ForEach(character.voiceStorage.indices, id: \.self) { index in
                        VStack(alignment: .center, spacing: 10) {
                            
                            // Date
                            Text(stringTimeStample(character.voiceStorage[index].timeStample))
                                .font(.caption)
                                .foregroundColor(Color.gray.opacity(0.6))
                                .bold()
                            
                            // voice cube
                            VoiceCubeView(character: $character, index: index)
                        }
                    }
                })
            }
            
        }.navigationBarTitle(Text(character.name))
    }

    
    // MARK: Convenient Functions
    private func stringTimeStample(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let timeString = formatter.string(from: date)
        return timeString
    }
    
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(character: .constant(mockCharacters[0]))
    }
}

struct VoiceCubeView: View {
    @Binding var character:Character
    var index:Int
    
    var body: some View {
        ZStack {
            
            // color cube
            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                .size(width: 85.0, height: 45.0)
                .foregroundColor(Color(character.backgroundColor[1]))
                .shadow(color: Color(character.backgroundColor[1]).opacity(0.8), radius: 10, x: 0.0, y: 5)
            
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: "waveform")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Text(String(character.voiceStorage[index].voiceClip) + "'")
                    .fontWeight(.bold)
                
                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.top, 12)
            .padding(.leading, 10)
            //                                }
        }.padding(.horizontal, 35)
        .padding(.bottom, 20)
    }
}
