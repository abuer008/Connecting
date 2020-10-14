//
//  SleepyState.swift
//  Connecting
//
//  Created by bowei xiao on 10.09.20.
//

import SpriteKit
import GameplayKit

class SleepyState: GKState {
    unowned var entity: OwlCharacter
    
    var elapsedTime:TimeInterval = 0.0
    
    var animationComponent:AnimationComponent {
        guard let animationComponent = entity.component(ofType: AnimationComponent.self) else {
            fatalError("Owl must have an AnimationComponent (SleepyState)")
        }
        return animationComponent
    }
    
    required init(entity: OwlCharacter) {
        self.entity = entity
    }
}

extension SleepyState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        elapsedTime = 0.0
        
        animationComponent.requestedAnimationState = .sleepy
    }
}
