//
//  PrototypeTouchState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypeTouchState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        
            print("enter ... \(currentState.rawValue)")
        runInteractionState(state: .touch, node: characterNode)
        HapticEffect.impactFeedback(style: .soft, intensity: 0.4)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        let delta = seconds - elapsedTime
        
        if delta < animaLength { return }
        
        /// switching states
        
        switchingStates()
        
        if currentState != .touch {
            switch currentState {
            case .idle:
                stateMachine?.enter(PrototypeIdleState.self)
            case .active:
                stateMachine?.enter(PrototypeActiveState.self)
            case .pair:
                stateMachine?.enter(PrototypePairState.self)
            case .success:
                stateMachine?.enter(PrototypeSuccessState.self)
            case .statistic:
                stateMachine?.enter(PrototypeStatisticState.self)
            case .pending:
                stateMachine?.enter(PrototypePendingState.self)
            default:
                stateMachine?.enter(PrototypeSleepyState.self)
            }
        }

        DispatchQueue.main.async {

            self.runInteractionState(state: .touch, node: self.characterNode)
        }
        
        elapsedTime = seconds
    }
}
