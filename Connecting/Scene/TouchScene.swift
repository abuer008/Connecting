//
// Created by bowei xiao on 18.10.20.
//

import SpriteKit

class TouchScene : SKScene {
  let characterNode:SKSpriteNode = SKSpriteNode(imageNamed: "H_standard_0")
  var requestedTextures:[SKTexture] = []
  let touchAnimaKey:String = "H_TouchAction"
  
  private func buildHTouchAtlas() {
    let touchAtlas = SKTextureAtlas(named: "H_TouchFront_2")
    let numImages = touchAtlas.textureNames.count - 1
    
    for i in (1...numImages) {
      requestedTextures.append(touchAtlas.textureNamed("\(i)"))
    }
  }
  
  override func didMove(to view: SKView) {
//    super.sceneDidLoad()
    self.size = CGSize(width: 456, height: 555)
    self.scaleMode = .aspectFill
    self.anchorPoint = CGPoint(x: 0.5, y: 0.4)
    backgroundColor = .clear
  
    characterNode.position = CGPoint(x: 0, y: 90)
    removeAllChildren()
    addChild(characterNode)
    
    view.allowsTransparency = true
    view.backgroundColor = .clear
    
    buildHTouchAtlas()
    
    let action = { SKAction.repeatForever(.animate(with: requestedTextures, timePerFrame: 1.0 / 12.0))} ()
    
    characterNode.removeAction(forKey: touchAnimaKey)
    characterNode.run(action, withKey: touchAnimaKey)
  }
}
