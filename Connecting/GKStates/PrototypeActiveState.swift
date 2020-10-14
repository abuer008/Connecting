//
//  PrototypeActiveState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypeActiveState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PrototypeTouchState.Type, is PrototypePendingState.Type, is PrototypePairState.Type, is PrototypeSuccessState.Type, is PrototypeStatisticState.Type:
            return false
        default:
            return true
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        print("enter ... \(currentState.rawValue)")
        runClipForState(state: .active, node: characterNode)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let delta = seconds - elapsedTime
        
        // debugging...
//        let delta2 = seconds - debuggingTime
//        if delta2 < 10.0 {
//            switchingStates() }
        
        if delta < animaLength { return }
        
        /// switching states
        switchingStates()
        
        
        if currentState != .active {
            switch currentState {
            case .idle:
                stateMachine?.enter(PrototypeIdleState.self)
            case .sleepy:
                stateMachine?.enter(PrototypeSleepyState.self)
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
        
        // debugging...
        debuggingTime = seconds
    }
}
