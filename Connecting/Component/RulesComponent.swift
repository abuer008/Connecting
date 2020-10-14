//
//  RulesComponent.swift
//  Connecting
//
//  Created by bowei xiao on 08.09.20.
//

import SpriteKit
import GameplayKit

protocol RulesComponentDelegate: class {
    func rulesComponent(rulesComponent: RulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem)
}

class RulesComponent:GKComponent {
    
    // MARK: Properties
    
    weak var delegate: RulesComponentDelegate?
    var ruleSystem: GKRuleSystem
    
    private var timeSinceRulesUpdate:TimeInterval = 0.0
    
    var animationComponent:AnimationComponent {
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { fatalError("A rulescomponent's entity must have a animationComponent")}
        return animationComponent
    }
    
    // MARK: Initialisation
    override init() {
        ruleSystem = GKRuleSystem()
        super.init()
    }
    
    init(rules: [GKRule]) {
        ruleSystem = GKRuleSystem()
        ruleSystem.add(rules)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: GKComponent life cycle

extension RulesComponent {
    
    override func update(deltaTime seconds: TimeInterval) {
        /// characteristic Input and ruleSystem evaluate
        timeSinceRulesUpdate += seconds
        let clipDuration = TimeInterval((animationComponent.currentClips?[0].textures.count)! / 30)
        if timeSinceRulesUpdate < clipDuration {
            return
        }
        
        if let character = entity as? OwlCharacter,
           let scene = character.component(ofType: RenderComponent.self)?.node.scene as? MainScene {
            
        }
        // passing data
        delegate?.rulesComponent(rulesComponent: self, didFinishEvaluatingRuleSystem: ruleSystem)
    }
}
