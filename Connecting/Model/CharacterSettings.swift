//
//  CharacterSettings.swift
//  Connecting
//
//  Created by bowei xiao on 15.09.20.
//

import SwiftUI
import Combine



// MARK: Character Store Data
// characteristic, attribute, personality settings

struct Settings {
    var characteristicValue:Double
    var attributeValue:Double
    var personalityValue:Double
}

class CharacterSettings: ObservableObject {
    @Published var characterSettings:[Character]
    
    init() {
        self.characterSettings = []
    }
    
    func addCharacter() {
        let newCharacter = Character(name: "Leandro", stateName: [.Idle: "I'm calm, blar blar blar...", .Active: "Working right now", .Sleepy: "em, em, em"], scene: PrototypeScene(), characterState: .Idle, colorSet: .blue, voiceStorage: [VoiceModel(isSource: true, voiceClip: 1, timeStample: Date(), voiceDuration: 12.0)])
        
        self.characterSettings.append(newCharacter)
    }
}

class UIState: ObservableObject {
    @Published var activeCharacter:Character = mockCharacters[0]
    @Published var animationState:AnimationState = .pending
    @Published var testString:String = "not passing"

    func newActiveCharacter(_ character:Character) {
        self.activeCharacter = character
        print("activeCharacter changed...")
    }

    func pairStateButton() {
        // state changes:
        // - pending, the standard blicking
        // - pair, the searching anima
        // - success, finish searching, play success anima
        self.animationState = .idle
        let isPair:Bool = self.animationState == .pair ? true : false

        UserDefaults.standard.setValue(isPair, forKey: "IsIdle")

        self.testString = "Passing through"
        print("\(self.animationState.rawValue)")
    }
}