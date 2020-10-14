//
//  TouchScene.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 09.10.20.
//

import SpriteKit

class TouchScene:SKScene {
    
    let characterNode:SKSpriteNode = SKSpriteNode(imageNamed: "standard_0")
    var requestedTextures:[SKTexture] = []
    let touchAnimaKey:String = "TouchAction"
    
    private func buildTouchAtlas() {
        
        for i in (1...3) {
            let touchAtlas = SKTextureAtlas(named: "TouchFront_\(i)")
            let numImages = touchAtlas.textureNames.count - 1
            
            for imageDigit in 0...numImages {
                requestedTextures.append(touchAtlas.textureNamed("\(imageDigit)"))
            }
        }
    }
    
//    private func combineTouchTextures() -> [SKTexture] {
//        var tempTextures:[SKTexture] = []
//
//        for touchTextures in requestedTextures {
//            tempTextures.append(contentsOf: touchTextures)
//        }
//
//        return tempTextures
//    }
    
    override func sceneDidLoad() {
        
        self.size = CGSize(width: 324, height: 394)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.43)
        addChild(characterNode)
        backgroundColor = .clear
        
        buildTouchAtlas()
        
        let action = { SKAction.repeatForever(.animate(with: requestedTextures, timePerFrame: 1.0 / 12.0)) } ()
        
        characterNode.removeAction(forKey: touchAnimaKey)
        characterNode.run(action, withKey: touchAnimaKey)
        
    }
}
