//
//  CharacterStackView.swift
//  Connecting
//
//  Created by bowei xiao on 20.09.20.
//

import SwiftUI

struct CharacterStackView: View {
  
  /// properties from `MainView`
  @Binding var isStacked: Bool
  @Binding var selectCharacter: Character
  
  /// properties for `StackView`
  
  @State var scaleParm: CGFloat = 1.0
  
  @State var showNextCard = false
  @State var yOffset: Int = 0
  
  @Namespace var namespace
    
    @ObservedObject var uiState: UIState
    @State private var deletingCharacter: Bool = false
    @State var deleteId = UUID()
//    @State var isListState:Bool = false

//    @State var characters: [Character] = mockCharacters
  @EnvironmentObject var characterSet: CharacterSettings
  
  /// properties for `Gesture event`
  @State var activingMainView: Bool = false
  
  @ViewBuilder var body: some View {
    content
  }
  
  
  var content: some View {
    
    ZStack {
      VStack {
        LazyVStack(alignment: .center, spacing: isStacked ? 0 : 185) {
          ForEach(Array(characterSet.characterSettings.enumerated()), id: \.1) { i, character in
            GeometryReader { bounds in
              
              ZStack {
                StackedSingleView(uiState: uiState, deleteId: $deleteId, isStacked: $isStacked, character: character, deletingCharacter: $deletingCharacter)
                    .rotation3DEffect(
                        .degrees(isStacked ? Double(bounds.frame(in: .global).height  + 7) : 0),
                        axis: (x: 90.0, y: 90.0, z: 270.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 0.3)
                    //                                        .rotation3DEffect(.degrees(bounds.frame(.global).minX - 10), axis: (x: 1, y: 0, z: 0))
                    .offset(x: isStacked ? 0 : bounds.size.width / 6, y: isStacked ? bounds.size.height + 200 : (bounds.frame(in: .global).minY / 50 - 160))
                    .scaleEffect(isStacked ? 1.2 : 0.9)
                
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





struct StackedSingleView: View {
    /// properties for `CharacterCardView`
    @ObservedObject var uiState:UIState
    @Binding var deleteId:UUID
    @Binding var isStacked:Bool
    var character:Character
  
    @Binding var deletingCharacter:Bool
    
    @State var isSingleCardBeenActived = false
    @State var showDetail: Bool = false
    @State var selectMain: Bool = false
  @State private var showing:Bool = false
    
    var body: some View {
        CharacterCardView(
            uiState: uiState,
            isSingleCardBeenActived: $isSingleCardBeenActived,
            deleteId: $deleteId,
            //                                radius: $radius,
            //                                index: index,
            showDetail: $showDetail,
            //                                scaleParm: $scaleParm,
            isListState: $isStacked,
            character: character,
            deletingCharacter: $deletingCharacter
        )
      
    }
}
