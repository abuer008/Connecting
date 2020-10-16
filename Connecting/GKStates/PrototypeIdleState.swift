//
//  IdleState.swift
//  Connecting
//
//  Created by bowei xiao on 05.10.20.
//
// idle state
/*
    1. enter .idle state
    2. generate facing direction and index
    3. loading textures
    4. if restTime <= 0
    5. generate new facing direction and index
 */

/* params:
    framesCount: how many frames in clip
    facingdirection
    index
 */

import SpriteKit
import GameplayKit

fileprivate let characterAnimationKey = "character Animation"

// MARK: The Base State
class PrototypeState: GKState {
    unowned var characterNode: SKNode
    
    var currentState:AnimationState = .pending
    
    var oldFacing:Bool { return UserDefaults.standard.bool(forKey: "OldFacing") }
    
    var elapsedTime:TimeInterval = 0.0
    var directionBias:Int = 0
    
    var animaLength:Double { return UserDefaults.standard.double(forKey: "restTime")}
    
    // debugging...
    var debuggingTime:TimeInterval = 0.0
    
    init(characterNode:SKNode) {
        self.characterNode = characterNode
        
        super.init()
    }
}

class PrototypeIdleState: PrototypeState {
}

// MARK: State Life Cycle
extension PrototypeIdleState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("enter ... \(currentState.rawValue)")
        runClipForState(state: .idle, node: characterNode)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let delta = seconds - elapsedTime
        
        
        if delta < animaLength { return }
        
        /// switching states
        switchingStates()
        
        if currentState != .idle {
            switch currentState {
            case .active:
                stateMachine?.enter(PrototypeActiveState.self)
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
            self.runClipForState(state: .idle, node: self.characterNode)
        }
        
        
        /// when anima is finished, and start new loop
//        ConvenientFunctions.runClipForState(state: .idle, oldClips: oldClips, deltaTime: seconds)
//        characterNode.removeAction(forKey: characterAnimationKey)
//        characterNode.run(action, withKey: characterAnimationKey)
        elapsedTime = seconds
        
    }
}
