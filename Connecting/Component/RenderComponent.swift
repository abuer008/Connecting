//
//  RenderComponent.swift
//  Connecting
//
//  Created by bowei xiao on 08.09.20.
//

import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    // MARK: Properties
    
    let node = SKNode()
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
}
