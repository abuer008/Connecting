//
//  PrototypePairState.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SpriteKit
import GameplayKit

class PrototypePairState: PrototypeState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }

    override func didEnter(from previousState: GKState?) {
//        currentState = .pair
        print("enter ... \(currentState.rawValue)")
        runInteractionState(state: .pair, node: characterNode)
    }

    override func update(deltaTime seconds: TimeInterval) {

        let delta = seconds - elapsedTime

        if delta < animaLength {
            return
        }

        /// switching states
//        runInteractionState(state: .pair, node: characterNode)

//        switchingStates()
//
//        if currentState != .pair {
//            switch currentState {
//            case .idle:
//                stateMachine?.enter(PrototypeIdleState.self)
//            case .active:
//                stateMachine?.enter(PrototypeActiveState.self)
//            case .sleepy:
//                stateMachine?.enter(PrototypeSleepyState.self)
//            case .success:
//                stateMachine?.enter(PrototypeSuccessState.self)
//            case .statistic:
//                stateMachine?.enter(PrototypeStatisticState.self)
//            case .pending:
//                stateMachine?.enter(PrototypePendingState.self)
//            default:
//                stateMachine?.enter(PrototypeTouchState.self)
//            }
//        }

//        DispatchQueue.main.async {
//            self.runInteractionState(state: .pair, node: self.characterNode)
//        }

        elapsedTime = seconds
    }
}
