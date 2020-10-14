//
//  PrototypePreparingState.swift
//  Connecting
//
//  Created by bowei xiao on 06.10.20.
//

import GameplayKit

class PrototypePreparingState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        stateMachine?.enter(PrototypeIdleState.self)
    }
}
