//
//  mainWithFamily.swift
//  Connecting
//
//  Created by bowei xiao on 04.08.20.
//

import SwiftUI

struct mainWithFamily: View {
    @Namespace var namespace
    
    /// global properties - reading ui state property
    @ObservedObject var uiState:UIState = UIState()

    /// environmentObject: ` characterSet`
    
    @EnvironmentObject var characterSet:CharacterSettings
    
    /// properties for `CharacterCardView`
    @State var characters: [Character] = mockCharacters
    @State var isSingleCardBeenActived = true
    @State var deleteId = UUID()
    var index:Int = 0
    @State var showDetail:Bool = false
    @State var radius:CGFloat = 40.0
    @State var scaleParm:CGFloat = 1.0
    @State var isListState:Bool = true
    @State private var deletingCharacter:Bool = false

    // selectCharacter is for stack mode of characters, shown the prime logo
    @State var selectCharacter:Character = mockCharacters[0]
    
    // debug healthdata
    @State private var value:Int = 0
    let healthData = HealthKitData()
    
    /// properties for `MainView`
    @State private var isStacked = true
//    @State private var mainCharacter:Character = mockCharacters[1]
    
    /// Properties for `PausePopView`
    @State private var isPausePopUp = false
    @State private var startPause = false
    
    /// properties for `Gesture event`
    
    @State private var dragData:CGSize = .zero
    
    
    @ViewBuilder
    
    var body: some View {
        if characterSet.characterSettings != [] {
            content
        }
    }
    
    var content: some View {
        let dragGesture = DragGesture()
            .onChanged { (value) in
                guard value.translation.height < 100 else { return }
                guard value.translation.height > -100 else { return }
                
                if isStacked {
                    guard value.translation.height < 10  else {
                        return
                    }
                }
                
                withAnimation(.spring()) {self.dragData = value.translation}
            }
            .onEnded { _ in
                withAnimation(.spring()) {if self.dragData.height < -50 {
                    isStacked = false
                    self.dragData = .zero
                } else if !isStacked && self.dragData.height > 50 {
                    isStacked = true
                    self.dragData = .zero
                }}
            }
        
        return ZStack {
            if showDetail {
                CharacterDetailView(character: $uiState.activeCharacter)
                    .opacity(showDetail ? 1 : 0)
                    .offset(y: showDetail ? 30 : 200)
            }
            
            
            CharacterCardView(
                isSingleCardBeenActived: $isSingleCardBeenActived,
                    deleteId: $deleteId,
                //                    activeIndex: $activeIndex,
                //                    radius: $radius,
                //                    index: index,
                showDetail: $showDetail,
                //                    scaleParm: $scaleParm,
                isListState: $isListState,
                character: characterSet.characterSettings.first!,
                    deletingCharacter: $deletingCharacter)
            
            
            HStack {
                VStack {

                    HStack {
                        if showDetail {
                            Button(action: {
                                showDetail.toggle()
                            }, label:  {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .frame(width: 45, height: 45, alignment: .center)
                            })
        
                            Text(uiState.activeCharacter.name)
                                .bold()
                                .matchedGeometryEffect(id: "Title", in: namespace, properties: .frame)
                                .font(.largeTitle)
                                .padding(.horizontal)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                                .font(.title)
                                .padding(.trailing, 50)
                        } else {
                            HStack {
                                Text("Families")
                                    .bold()
                                    .matchedGeometryEffect(id: "Title", in: namespace, properties: .frame)
                                    .font(.largeTitle)
                                    .padding(.horizontal, 60)
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.isPausePopUp = true
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: !startPause ? "pause.circle" : "pause.circle.fill")
                                            .font(.title)
                                            .foregroundColor(!startPause ? .primary : .red)
//                                            .frame(width: 30, height: 30, alignment: .center)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0.0, y: 4.0)
                                            Text("Pause")
                                                .font(.caption)
                                                .bold()
                                    }
                                })
                            }
                        }
                    }
//                    .padding(.leading, 5)
                    Spacer()
                }
                .padding(.top, 60)
                Spacer()
            }
            
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .opacity(isStacked ? 0 : 1)
            
            CharacterStackView(isStacked: $isStacked, selectCharacter: $characterSet.characterSettings[0], uiState: uiState)
                .blur(radius: showDetail ? 30 : 0)
                .offset(y: showDetail ? 150 : 0)
                .offset(y: dragData.height)
                .gesture(dragGesture)
            
//            Text("\(value)")
            
            // debugging...
            
            // PausePopUp
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .opacity(isPausePopUp ? 1 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) { isPausePopUp = false }
                    }
            GeometryReader { bounds in
                HStack {
                    Spacer()
                    PausePopView(isPausePopUp: $isPausePopUp, startPause: $startPause)
                        .rotation3DEffect(
                            Angle(degrees: isPausePopUp ? 0 : 30),
                            axis: (x: -1.0, y: 0.0, z: 0.0),
                            anchor: .top,
                            anchorZ: 0.0,
                            perspective: 1.0
                        )
                        .offset(y: isPausePopUp ? bounds.frame(in: .global).height / 4 : bounds.frame(in: .global).minY - 240)
                        .blur(radius: isPausePopUp ? 0.0 : 10.0)
                        .opacity(isPausePopUp ? 1.0 : 0.0)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            healthData.start()
            self.value = healthData.heartRateValue
        }
    }
    
}

struct mainWithFamily_Previews: PreviewProvider {
    static var previews: some View {
        mainWithFamily().environmentObject(CharacterSettings())
    }
}
