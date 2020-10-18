//
//  prototypeScene.swift
//  Connecting
//
//  Created by bowei xiao on 16.09.20.
//

import SpriteKit
import SwiftUI
import GameplayKit

class PrototypeScene:SKScene, TouchHandleDelegate {
    
    var characterNode:SKNode?
    var stateMachine:GKStateMachine!
//    var bScene:SKScene?
    var elapsedTime:TimeInterval = 0.0
    
    func setUpScene() {
//        bScene = SKScene(fileNamed: "PrototypeSceneSKS")
        self.size = CGSize(width: 456, height: 555)
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        self.backgroundColor = .clear
        
//        characterNode = SKNode()
//        characterNode = bScene?.childNode(withName: "owlCharacter")
        characterNode = SKSpriteNode(imageNamed: "H_standard_0")
        characterNode?.position = CGPoint(x: 0, y: 90)
//        bScene?.addChild(characterNode!)
        self.removeAllChildren()
        self.addChild(characterNode!)
        
        stateMachine = GKStateMachine(states: [
            PrototypePendingState(characterNode: characterNode!),
            PrototypeIdleState(characterNode: characterNode!),
            PrototypeActiveState(characterNode: characterNode!),
            PrototypeSleepyState(characterNode: characterNode!),
            PrototypePairState(characterNode: characterNode!),
            PrototypeSuccessState(characterNode: characterNode!),
            PrototypeStatisticState(characterNode: characterNode!),
            PrototypeTouchState(characterNode: characterNode!)
        ])

        stateMachine.enter(PrototypePendingState.self)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
//        view.presentScene(bScene)
        view.allowsTransparency = true
        view.backgroundColor = .clear
    }
    
    override func update(_ currentTime:TimeInterval) {
        super.update(currentTime)
//        let deltaTime = currentTime - elapsedTime
//
//        if deltaTime < 3.0 { print("scene updating...") }
//        print("testing...")
        stateMachine.update(deltaTime: currentTime)
        
//        elapsedTime = currentTime
    }
    
    func handleTouch(_ connection: SharedConnectivity, message: Double) {
        print("transfer data.")
    }
}

