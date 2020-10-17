//
//  PrototypeSuccessState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypeSuccessState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        
            print("enter ... \(currentState.rawValue)")
        runInteractionState(state: .success, node: characterNode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stateMachine?.enter(PrototypeIdleState.self)
            UserDefaults.standard.setValue(false, forKey: "IsPair")
            UserDefaults.standard.setValue(true, forKey: "IsConnect")
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {

    }
}
