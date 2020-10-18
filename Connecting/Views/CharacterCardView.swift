//
//  CharacterCardView.swift
//  Connecting
//
//  Created by bowei xiao on 16.09.20.
//

import SwiftUI
import SpriteKit

enum CardState {
  case Active
  case Stack
  case Detail
}

struct CharacterCardView: View {
  // MARK: Properties
  /// global properties
  
  @StateObject var uiState = UIState()
//  @StateObject var characterSet: CharacterSettings = CharacterSettings()
  
  /// ist single card been actived, only return `true` when it's able into `CharacterDetailView`
  @Binding var isSingleCardBeenActived: Bool
  @Binding var deleteId: UUID
  
  /// The  prime character card, default character should be the `first` of characters list
//    @Binding var activeIndex: Int
  
  /// The corner radius of card
//    @Binding var radius:CGFloat
  
  /// The index of current character card
//    var index: Int
  
  @Binding var showDetail: Bool

//    @Binding var scaleParm:CGFloat
  
  /// is card view in list view state
  @Binding var isListState: Bool
  
  
  // Character Properties
  /// character name
  /// state name
  /// SKScene
  /// background1
  /// background2
  /// isConnected
  var character: Character
  
  // private Properties
  
  @State private var activingMainView: Bool = false
  @State private var selectedDeletingCharacter: Bool = false
  @Binding var deletingCharacter: Bool
//    @State private var characters:[Character] = mockCharacters
  @EnvironmentObject var characterSet: CharacterSettings
  // detail view can only showing when both return true
  var showDetailView: Bool {
    if isSingleCardBeenActived && showDetail {
      return true
    }
    return false
  }
  
  /// properties for `Gesture event`
  @GestureState var pressState = false
  
  var body: some View {
    
    
    let pressGesture = LongPressGesture(minimumDuration: 0.8, maximumDistance: 10)
            .updating($pressState, body: { (currentState, gestureState, transition) in
              if !isSingleCardBeenActived && !isListState {
                gestureState = currentState
              }
            })
            .onEnded { (_) in
              // set the new active card based on index
              HapticEffect.hapticFeedback(type: .success)
//                HapticEffect.impactFeedback(style: .soft, intensity: 3)
              uiState.newActiveCharacter(character)
            }
    
    // SpriteKit Scene View
    VStack {
      ZStack {
        ZStack {
          
          /// 1. `Sprite view` for content display
          SpriteView(scene: character.scene, options: .allowsTransparency)
                  
                  // Character color setting
                  .hueRotation(Angle(degrees: character.characterColor.0))
                  .saturation(character.characterColor.1)
                  
                  .scaleEffect(showDetailView ? 0.9 : 1.3)
                  
                  // for detail view position
                  .overlay(
                          LineObject()
                  )
                  .offset(x: showDetailView ? -60 : 0, y: showDetailView ? 35 : 0)
                  
                  // background color setting
                  .background(background)
                  // posisition and size of character
                  .frame(width: showDetailView ? .infinity : 250, height: 303)
                  
                  // Card shape
                  .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                  //                    .scaleEffect(activeIndex == index ? scaleParm : 1)
                  
                  // position of Card
                  //                .offset(x: 0, y: showDetailView ? -213 : 0)
                  .shadow(color: Color(character.backgroundColor[1]).opacity(0.5), radius: 15, x: 0.0, y: 15.0)
                  
                  // Gestures event
                  .gesture(pressGesture)
          
          // debugging
          
          /// 2. `delete button`, only avariable in list state
          if !isSingleCardBeenActived && !isListState {
            Button(action: {
              print("delete button tapped")
              // sending id data to external
              withAnimation(.spring()) {
                deleteId = character.id
                // private state change for internal view change
//                selectedDeletingCharacter.toggle()
                // public binding change for external view change
//                deletingCharacter.toggle()
                selectedDeletingCharacter.toggle()
                deletingCharacter.toggle()
              }
            }, label: {
              ZStack {
                Circle()
                        .trim(from: pressState ? 0.001 : 1, to: 1)
                        .stroke(lineWidth: 5.0)
                        .foregroundColor(.green)
                        .rotation3DEffect(
                                Angle(degrees: 180),
                                axis: (x: 1.0, y: 0.0, z: 0.0)
                        )
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 38, height: 38)
                        .shadow(color: .green, radius: 5, x: 0, y: 0)
                        .opacity(pressState ? 1 : 0)
                Image(systemName: selectedDeletingCharacter ? "chevron.compact.down" : "multiply.circle.fill")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
              }
            })
                    .offset(x: 88, y: -115)
          }
          
          /// 3. mark for `Prime character`
          if !isSingleCardBeenActived && !isListState && uiState.activeCharacter.id == character.id && !selectedDeletingCharacter {
            VStack {
              HStack {
                Image(systemName: "eye.fill")
                Text("Prime")
              }
                      .font(.headline)
                      .foregroundColor(.white)
                      .padding(8)
                      .background(Color.white.opacity(0.3))
                      .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                      .offset(x: -55)
              Spacer()
            }
                    .padding(20)
          }
          
          /// 4. Button for `Show Detail View`
          if !showDetail && isListState {
            HStack {
              VStack {
                Button(action: {
                  withAnimation(.easeInOut) {
                    showDetail.toggle()
                  }
                }, label: {
                  Image(systemName: "eye.fill")
                          .font(.headline)
                          .foregroundColor(.white)
                          .padding(10)
                          .background(Color.white.opacity(0.4))
                          .clipShape(Circle())
                          .padding(.leading, 80)
                })
                        .padding(.top, 275)
                Spacer()
              }
              Spacer()
            }
          }
          
          /// 5. `State text`
          if !selectedDeletingCharacter {
            Text(character.stateName[character.characterState]!)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(showDetailView ? .leading : .center)
                    .frame(width: 120, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: showDetailView ? 50 : 0, y: showDetailView ? 50 : -50)
          }
          
          if selectedDeletingCharacter {
            VStack {
              DeleteView(deleteId: $deleteId, deletingCharacter: $selectedDeletingCharacter, characterSet: characterSet)
              .padding(.top, 50)
              Spacer()
            }
          }
        }
                .scaleEffect(pressState ? 1.2 : 1)
                .animation(.spring())
        
        
      }
              //              .zIndex(selectedDeletingCharacter ? 10 : 0)
              .offset(y: selectedDeletingCharacter ? -100 : 0)
      
      if showDetailView {
        Spacer()
      }
    }
//        .edgesIgnoringSafeArea(.all)
  }
  
  var background: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [Color(character.backgroundColor[0]), Color(character.backgroundColor[1])]), startPoint: .top, endPoint: .bottom)
      
      // shown as main mark
    }
  }
}

struct CharacterCardView_Previews: PreviewProvider {
  
  static var previews: some View {
    CharacterCardView(isSingleCardBeenActived: .constant(false), deleteId: .constant(UUID()), showDetail: .constant(false), isListState: .constant(false), character: mockCharacters[0], deletingCharacter: .constant(false))
            .environmentObject(CharacterSettings())
  }
}

struct LineObject: View {
  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 5)
              .frame(width: 7, height: 4, alignment: .center)
      RoundedRectangle(cornerRadius: 5)
              .frame(width: 10, height: 4, alignment: .center)
      RoundedRectangle(cornerRadius: 5, style: .circular)
              .frame(width: 190, height: 4, alignment: .center)
    }
            .offset(y: 117)
            .opacity(0.3)
  }
}

