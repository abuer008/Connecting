//
//  CharacterStackView.swift
//  Connecting
//
//  Created by bowei xiao on 20.09.20.
//

import SwiftUI

struct CharacterStackView: View {
    
    /// properties from `MainView`
    @Binding var isStacked:Bool
    @Binding var selectCharacter:Character
    
    /// properties for `StackView`
    
    @State var scaleParm:CGFloat = 1.0
    
    @State var showNextCard = false
    @State var yOffset:Int = 0
    
    @Namespace var namespace
    
    /// properties for `CharacterCardView`
    @ObservedObject var uiState:UIState

    @State var isSingleCardBeenActived = false
    @State var activeIndex:Int = -1
    @State var index = 0
    @State var radius:CGFloat = 30.0
    @State var showDetail:Bool = false
    @State var selectMain:Bool = false
//    @State var isListState:Bool = false
    
    @State var characters: [Character] = mockCharacters
    
    /// properties for `Gesture event`
    @State var activingMainView:Bool = false
    
    @ViewBuilder var body: some View {
            content     
    }
    
    
    var content: some View {
        
        
        VStack {
            LazyVStack(alignment: .center, spacing: isStacked ? 0 : 185) {
                ForEach(characters.indices, id: \.self) { index in
                    GeometryReader { bounds in
                        
                        ZStack {
                            CharacterCardView(
                                uiState: uiState,
                                isSingleCardBeenActived: $isSingleCardBeenActived,
//                                activeIndex: $activeIndex,
//                                radius: $radius,
//                                index: index,
                                showDetail: $showDetail,
//                                scaleParm: $scaleParm,
                                isListState: $isStacked,
                                character: $characters[index]
                            )
                            .rotation3DEffect(
                                .degrees(isStacked ? Double(index * -5 + 5) : 0),
                                axis: (x: 90.0, y: 90.0, z: 270.0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 0.3)
                            .offset(x: isStacked ? 0 : bounds.size.width / 6, y: isStacked ? bounds.size.height + 200 : (bounds.frame(in: .global).minY / 50 - 160))
                            .scaleEffect(isStacked ? 1.2 : 0.9)
                            
                            if selectCharacter.id == characters[index].id && !isStacked {
                            }
                        }
                    }
                }
            }
        }
    }
    
    // convenient functions for dynamic angle setting
    func getAngleMuliplier(bounds: GeometryProxy) -> Double {
        if bounds.size.height > 406 {
            return 20
        }
        return 10
    }
    
    func getAngleOfCard(upponBounds: GeometryProxy, underBounds: GeometryProxy) -> Double {
        let upponChange = Double(upponBounds.frame(in: .global).minY - 30)
        let underChange = Double(-getAngleMuliplier(bounds: underBounds))
        
        return upponChange / underChange
    }
}

struct CharacterStackView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterStackView(isStacked: .constant(false), selectCharacter: .constant(mockCharacters[0]), uiState: UIState())
    }
}



