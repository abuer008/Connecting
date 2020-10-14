//
//  IntelligentComponent.swift
//  Connecting
//
//  Created by bowei xiao on 09.09.20.
//

import SpriteKit
import GameplayKit

class IntelligenceComponent: GKComponent {
    // MARK: Properties
    
    let stateMachine: GKStateMachine
    
    let initialStateClass: AnyClass
    
    // MARK: Initialisation
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        let firstState = states.first!
        initialStateClass = type(of: firstState)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: GKComponent life cycle

extension IntelligenceComponent {
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        stateMachine.update(deltaTime: seconds)
    }
    
    // Action
    func enterInitialState() {
        stateMachine.enter(initialStateClass)
    }
}
