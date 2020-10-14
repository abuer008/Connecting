//
//  OwlCharacter.swift
//  Connecting
//
//  Created by bowei xiao on 08.09.20.
//

import SpriteKit
import GameplayKit

class OwlCharacter: GKEntity {
    
    
    // MARK: Properties
    
    static var textureSize = CGSize(width: 456, height: 555)
    
    static var animations: [AnimationState: [FacingDirection: [ClipsIndex: Clip]]]?
    
    static func loadResources() {
        let handyAtlasNames = [
            "H_IdleFront",
            "H_IdleSide",
            "H_ActiveFront",
            "H_ActiveSide",
            "H_SleepyFront",
            "H_SleepySide"
        ]

        SKTextureAtlas.preloadTextureAtlasesNamed(handyAtlasNames) {
            error, characterAtlas in
            if let error = error {
                fatalError("(OwlCharacter: preloadTextureAtlases): One or more texture atlases could not be found: \(error).")
            }

//            animations = [:]
            animations?[.idle] = [FacingDirection.front:  AnimationComponent.animationsFromAtlas(atlas: characterAtlas[0], withImageIdentifier: "H_IdleFront", forAnimationState: .idle, facingDirection: .front, numberOfClips: .thirdteenth),
                                  FacingDirection.side: AnimationComponent.animationsFromAtlas(atlas: characterAtlas[1], withImageIdentifier: "H_IdleSide", forAnimationState: .idle, facingDirection: .side, numberOfClips: .sixth)]

            animations?[.active] = [FacingDirection.front:
                                        AnimationComponent.animationsFromAtlas(
                                            atlas: characterAtlas[2],
                                            withImageIdentifier: "H_ActiveFront",
                                            forAnimationState: .active,
                                            facingDirection: .front,
                                            numberOfClips: .ninth),
                                    FacingDirection.side:
                                        AnimationComponent.animationsFromAtlas(
                                            atlas: characterAtlas[3],
                                            withImageIdentifier: "H_ActiveSide",
                                            forAnimationState: .active,
                                            facingDirection: .side,
                                            numberOfClips: .seventh)]

            animations?[.sleepy] = [FacingDirection.front:
                                        AnimationComponent.animationsFromAtlas(
                                            atlas: characterAtlas[4],
                                            withImageIdentifier: "H_SleepyFront",
                                            forAnimationState: .sleepy,
                                            facingDirection: .front,
                                            numberOfClips: .eighth),
                                    FacingDirection.side:
                                        AnimationComponent.animationsFromAtlas(
                                            atlas: characterAtlas[5],
                                            withImageIdentifier: "H_SleepySide",
                                            forAnimationState: .sleepy,
                                            facingDirection: .side,
                                            numberOfClips: .eighth)]
        }
    }
    
    // MARK: Components
    
    // RenderComponent
    var renderComponent: RenderComponent {
        guard let renderComponent = component(ofType: RenderComponent.self) else {
            fatalError("A Character Entity must have an RenderComponent")
        }
        return renderComponent
    }
    
    // MARK: Initialisers
    
    override init() {
        // renderComponent
        // interationComponent
        // animationComponent
        // stateComponent
//        OwlCharacter.loadResources()
        
        super.init()
        
        let renderComponent = RenderComponent()
        addComponent(renderComponent)
        
//        let rulesComponent = RulesComponent(rules: [])
//        addComponent(rulesComponent)
//        rulesComponent.delegate = self
        
        guard let animation = OwlCharacter.animations else {
            fatalError("no initial anima...")
        }
        
        let animationComponent = AnimationComponent(textureSize: CGSize(width: 456, height: 555))
        addComponent(animationComponent)
        
        renderComponent.node.addChild(animationComponent.node)
        
        let intelligenceComponent = IntelligenceComponent(states: [
            // character states
            IdleState(entity: self),
            ActiveState(entity: self),
            SleepyState(entity: self)
        ])
        addComponent(intelligenceComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
