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
    @Published var activeCharacter:Character?
    
    init() {
        self.characterSettings = []
    }
    
    func addCharacter() {
      print("\(self.characterSettings.count)")
        let mockIndex = self.characterSettings.count
//        let newCharacter = Character(name: "Leandro", stateName: [.Idle: "I'm calm, blar blar blar...", .Active: "Working right now", .Sleepy: "em, em, em"], scene: PrototypeScene(), characterState: .Idle, colorSet: .blue, voiceStorage: [VoiceModel(isSource: true, voiceClip: 1, timeStample: Date(), voiceDuration: 12.0)])
        let newCharacter = mockCharacters[mockIndex]
        self.characterSettings.append(newCharacter)
        HapticEffect.hapticFeedback(type: .success)
        print("now characterArray has \(self.characterSettings.count) characters")
    }

    func deleteCharacter(id:UUID) {
        print("Button tapped")
        for character in characterSettings {
            if character.id == id {
                print("matched character")
                guard let deletingIndex = characterSettings.firstIndex(of: character) else {
                    print("\(#function): no matched index.")
                    return
                }
                characterSettings.remove(at: deletingIndex)
            }
        }
    }
    
    func setActiveCharacter(id:UUID) {
        for character in characterSettings {
            if character.id == id {
//                guard let activeIndex = characterSettings.firstIndex(of: character) else { return }
                activeCharacter = character
//                characterSettings.move(character, to: 0)
            }
        }
    }
}

class UIState: ObservableObject {
    @Published var activeCharacter:Character = mockCharacters[0]
    @Published var animationState:AnimationState = .pending
    @Published var isPair:Bool = false
    @Published var isConnect:Bool = false
    
    @Published var isTouched:Bool = false

    func newActiveCharacter(_ character:Character) {
        self.activeCharacter = character
        print("activeCharacter changed...")
    }

    func pairStateButton(requestedState:AnimationState) {
        switch requestedState {
        case .pair:
            isPair = true
            isConnect = false
        case .success:
            isPair = true
            isConnect = true
        case .pending:
            isPair = false
            isConnect = false
        default:
            isPair = false
            isConnect = true
        }

        UserDefaults.standard.setValue(isPair, forKey: "IsPair")
        UserDefaults.standard.setValue(isConnect, forKey: "IsConnect")
    }

    func resetPairState() {
        self.isPair = false
        self.isConnect = true
        self.animationState = .idle
        UserDefaults.standard.setValue(isPair, forKey: "IsPair")
        UserDefaults.standard.setValue(isConnect, forKey: "IsConnect")
    }
}