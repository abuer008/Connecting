//
//  PrototypeSleepyState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypeSleepyState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("enter ... \(currentState.rawValue)")
            runClipForState(state: .sleepy, node: characterNode)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        let delta = seconds - elapsedTime
        
        if delta < animaLength { return }
        
        /// switching states
        
        switchingStates()
        
        if currentState != .sleepy {
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
                stateMachine?.enter(PrototypeTouchState.self)
            }
        }
        
        DispatchQueue.main.async {
            self.runClipForState(state: self.currentState, node: self.characterNode)
        }
        
        elapsedTime = seconds
    }
}
