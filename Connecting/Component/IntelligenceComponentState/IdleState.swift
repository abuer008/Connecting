//
//  IdleState.swift
//  Connecting
//
//  Created by bowei xiao on 10.09.20.
//

import SpriteKit
import GameplayKit

class IdleState: GKState {
    unowned var entity: OwlCharacter
    
    var elapsedTime: TimeInterval = 0.0
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity.component(ofType: AnimationComponent.self) else {
            fatalError("Owl must have an AnimationComponent (IdleState)")
        }
        
        return animationComponent
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity.component(ofType: RenderComponent.self) else {
            fatalError("Owl must have an RenderComponent (IdleState)")
        }
        return renderComponent
    }
    
    var node = SKSpriteNode()
    
    
    init(entity:OwlCharacter) {
        self.entity = entity
    }
}

extension IdleState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        elapsedTime = 0.0
        
        animationComponent.requestedAnimationState = .idle
    }
}
