//
//  SceneDeactiveState.swift
//  Connecting
//
//  Created by bowei xiao on 10.09.20.
//

import GameplayKit

class SceneDeactiveState: GKState {
    unowned let mainScene: MainScene
    
    init(mainScene: MainScene) {
        self.mainScene = mainScene
    }
}
