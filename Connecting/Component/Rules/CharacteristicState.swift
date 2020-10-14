//
//  CharacteristicState.swift
//  Connecting
//
//  Created by bowei xiao on 28.09.20.
//

import GameplayKit

class CharacteristicState {
    
    // MARK: Properties
    
    var characteristicState: Settings
    
    // MARK: Initialisation
    
    init(characterSettings:Settings) {
        let characteristicRandomMean = characterSettings.characteristicValue
        
        self.characteristicState = characterSettings
    }
}
