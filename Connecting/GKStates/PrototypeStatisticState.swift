//
//  PrototypeStatisticState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypeStatisticState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        
            print("enter ... \(currentState.rawValue)")
        runInteractionState(state: .statistic, node: characterNode)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        let delta = seconds - elapsedTime
        
        if delta < animaLength { return }
        
        /// switching states
        
        switchingStates()
        
        if currentState != .statistic {
            switch currentState {
            case .idle:
                stateMachine?.enter(PrototypeIdleState.self)
            case .active:
                stateMachine?.enter(PrototypeActiveState.self)
            case .pair:
                stateMachine?.enter(PrototypePairState.self)
            case .success:
                stateMachine?.enter(PrototypeSuccessState.self)
            case .sleepy:
                stateMachine?.enter(PrototypeSleepyState.self)
            case .pending:
                stateMachine?.enter(PrototypePendingState.self)
            default:
                stateMachine?.enter(PrototypeTouchState.self)
            }
        }
        
        DispatchQueue.main.async {
            self.runInteractionState(state: .statistic, node: self.characterNode)
        }
        
        elapsedTime = seconds
    }
}
