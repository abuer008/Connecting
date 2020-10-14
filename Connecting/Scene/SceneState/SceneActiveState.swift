//
//  SceneActiveState.swift
//  Connecting
//
//  Created by bowei xiao on 10.09.20.
//

import GameplayKit

class SceneActiveState: GKState {
    unowned let mainScene: MainScene
    
    init(mainScene: MainScene) {
        self.mainScene = mainScene
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
}
