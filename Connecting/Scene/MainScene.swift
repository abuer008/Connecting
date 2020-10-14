//
//  MainScene.swift
//  Connecting
//
//  Created by bowei xiao on 08.09.20.
//

import SwiftUI
import SpriteKit
import GameplayKit

class MainScene:SKScene {
    
    // MARK: Properties
    
//    let basicScene = SKScene(fileNamed: "BasicScene")
    let basicScene = SKScene()
    
    let sceneSize = CGSize(width: 456, height: 555)
    
    let owlCharacter = OwlCharacter()
    var characterEntity = Set<GKEntity>()
    
    var lastUpdateTimeInterval:TimeInterval = 0.0
    let maximumUpdateDeltaTime:TimeInterval = 1.0 / 60.0
    
//    lazy var stateMachine: GKStateMachine = GKStateMachine(states:
//        [SceneActiveState(mainScene: self),
//        SceneDeactiveState(mainScene: self)]
//    )
    
    let debugText = SKLabelNode(text: "Clip")
    
    // MARK: Characteristic setting Input
    
    @EnvironmentObject var characterSettings:CharacterSettings
    
    
    // MARK: Health Data Input (Rule State)
    
    // MARK: UI Status Input
    
    // the Entity of owlCharacter
    // Nodes
    
    // generate the customer Infos for Rules evaluating...
    
    // MARK: Component System
    
        // preper component system for the scene update
    lazy var componentSystems:[GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
//        let rulesSystem = GKComponentSystem(componentClass: RulesComponent.self)
        
        return [intelligenceSystem, animationSystem]
    }()
    
    // set up Scene
    func setUpScene(view: SKView) {

        basicScene.scaleMode = .aspectFill
        basicScene.anchorPoint = CGPoint(x: 0.5, y: 0.4)

        basicScene.backgroundColor = .clear
        print("basicScene loading...")

        view.presentScene(basicScene)
        view.allowsTransparency = true
        view.backgroundColor = .clear
        view.ignoresSiblingOrder = true
    }
    
}

extension MainScene {
    // MARK: Intialisation
    
    
    
    
    // MARK: Scene Life Cycle
    override func sceneDidLoad() {
        // check the connection of character
//        OwlCharacter.loadResources()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // find the points of character
        // set the character's initial position
        // add to the scene
        setUpScene(view: view)
        addEntity(entity: owlCharacter)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard view != nil else { return }
        
        var deltaTime = currentTime - lastUpdateTimeInterval
        
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        
        lastUpdateTimeInterval = currentTime
        
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
    }
}

// convenience
extension MainScene {
    
    func addEntity(entity: GKEntity) {
        characterEntity.insert(entity)
        
        
        for componentSystem in self.componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let renderNode = entity.component(ofType: RenderComponent.self)?.node {
//            addNode(node: renderNode, toPath: "/Character/")
//            basicScene?.addChild(renderNode)
//            renderNode.position = characterNode.position
            renderNode.removeFromParent()
            basicScene.addChild(renderNode)
        }
        
        if let intelligenceComponent = entity.component(ofType: IntelligenceComponent.self) {
            intelligenceComponent.enterInitialState()
        }
    }
    
    func addCharacter(character: SKNode, parentName: String) {
        let characterNode:SKNode? = basicScene.childNode(withName: parentName)
        
        if characterNode != nil {
            characterNode!.addChild(character)
        }
    }
}
