//
//  GameScene.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.08.20.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    // MARK: Varibles
    
    let characterNode = SKSpriteNode(imageNamed: "standard_0")
    
    var requestTextures:[SKTexture] = []
    var requestState:WatchStates = .Idle
    
    var elapsedTime:TimeInterval = 0.0
    var animaLength:TimeInterval = 0.0
    
    let animaActionKey:String = "watchAutoAction"
    
    // MARK: The States and FacingDirection for Watch
    
    enum WatchStates:String {
        case Idle
        case Active
        case Sleepy
        
        case Blinking
        case Success
        case Searching
        case Dictation
        
        case Initial
        case PairSearching
    }
    
    enum FacingDirection:String {
        case Front
        case Side
    }
    
    // MARK: Hard coding animation sequences
    let animaArray = [
        [   /// Idle state
            [(FacingDirection.Front, 1), (FacingDirection.Front, 5), (FacingDirection.Front, 10), (FacingDirection.Front, 4), (FacingDirection.Front, 12), (FacingDirection.Front, 13), (FacingDirection.Front, 1), (FacingDirection.Front, 6)],
            [(FacingDirection.Front, 3), (FacingDirection.Front, 8), (FacingDirection.Side, 1), (FacingDirection.Side, 2), (FacingDirection.Side, 5), (FacingDirection.Side, 6), (FacingDirection.Front, 10), (FacingDirection.Front, 13)],
            [(FacingDirection.Side, 1), (FacingDirection.Side, 3), (FacingDirection.Side, 4), (FacingDirection.Side, 6), (FacingDirection.Front, 9), (FacingDirection.Front, 2), (FacingDirection.Front, 9), (FacingDirection.Front, 13), (FacingDirection.Front, 12)],
            [(FacingDirection.Front, 13), (FacingDirection.Front, 1), (FacingDirection.Side, 1), (FacingDirection.Side, 2), (FacingDirection.Side, 4), (FacingDirection.Side, 5), (FacingDirection.Side, 6), (FacingDirection.Front, 1)],
            [(FacingDirection.Front, 2), (FacingDirection.Front, 13), (FacingDirection.Front, 6), (FacingDirection.Front, 7), (FacingDirection.Front, 13), (FacingDirection.Front, 10), (FacingDirection.Front, 1), (FacingDirection.Front, 1)]
        ],
        [   /// Active state
            [ (FacingDirection.Front, 1), (FacingDirection.Front, 2), (FacingDirection.Front, 5), (FacingDirection.Front, 7), (FacingDirection.Front, 3), (FacingDirection.Front, 2), (FacingDirection.Front, 1), (FacingDirection.Front, 6)],
            [ (FacingDirection.Front, 1), (FacingDirection.Front, 6), (FacingDirection.Front, 7), (FacingDirection.Front, 9), (FacingDirection.Side, 1), (FacingDirection.Side, 5), (FacingDirection.Side, 5), (FacingDirection.Side, 7)],
            [ (FacingDirection.Side, 1), (FacingDirection.Side, 5), (FacingDirection.Side, 4), (FacingDirection.Side, 5), (FacingDirection.Side, 7), (FacingDirection.Front, 1), (FacingDirection.Front, 4), (FacingDirection.Front, 9)],
            [ (FacingDirection.Side, 1), (FacingDirection.Side, 2), (FacingDirection.Side, 5), (FacingDirection.Side, 6), (FacingDirection.Side, 5), (FacingDirection.Side, 6), (FacingDirection.Side, 4), (FacingDirection.Side, 7)]
        ],
        [   /// Sleepy state
            [ (FacingDirection.Front, 1), (FacingDirection.Front, 2), (FacingDirection.Front, 3), (FacingDirection.Front, 4), (FacingDirection.Front, 6), (FacingDirection.Front, 8)],
            [ (FacingDirection.Side, 1), (FacingDirection.Side, 4), (FacingDirection.Side, 2), (FacingDirection.Side, 3), (FacingDirection.Side, 5), (FacingDirection.Side, 8)],
            [ (FacingDirection.Side, 1), (FacingDirection.Side, 7), (FacingDirection.Side, 2), (FacingDirection.Side, 6), (FacingDirection.Side, 2), (FacingDirection.Side, 8)]
        ],
        [   /// Blink state: for no connection
            [ (FacingDirection.Front, 2)]
        ],
        [   /// Searching state: for statistic view
            [ (FacingDirection.Front, 1) ], [ (FacingDirection.Front, 2) ]
        ],
        [   /// Success state: for success connection
            [ (FacingDirection.Front, 1) ]
        ],
        [   /// Dictation state: for sending voice mail
            [ (FacingDirection.Front, 1)], [(FacingDirection.Front, 2)]
        ],
        [   /// PairSearching for searching new character
            [(FacingDirection.Front, 1)], [(FacingDirection.Front, 2)]
        ]
    ]
    
    // critica state
    private func switchingState() {
        let isPairing:Bool = UserDefaults.standard.bool(forKey: "PairingState")
        let isConnecting:Bool = UserDefaults.standard.bool(forKey: "ConnectState")
        let activeStatistic:Bool = UserDefaults.standard.bool(forKey: "ActiveStatistic")
        let showDictation:Bool = UserDefaults.standard.bool(forKey: "ShowDictation")
        
        switch true {
        case !isPairing && !isConnecting:
            requestState = .Blinking
        case isPairing && !isConnecting:
            requestState = .PairSearching
        case isPairing && isConnecting:
            requestState = .Success
        case activeStatistic:
            requestState = .Searching
        case showDictation:
            requestState = .Dictation
        default:
            requestState = .Idle
        }
    }
    
    /// main function for generate new animation
    private func requestAnimaSet(_ state:WatchStates) {
        
        
        // set random sets
        let choosingSet = randomSet(state: state)
        
        // build mulitiple texture atlas
        for set in choosingSet {
            let tempAtlas = buildAtlas(state: state, animaSet: set)
            self.requestTextures.append(contentsOf: tempAtlas)
        }
        
        animaLength = TimeInterval(Double(requestTextures.count) / 12.0)
        
        // combine textures
    }
    
    private func randomSet(state:WatchStates) -> [(FacingDirection, Int)] {
        var randomNum:Int = 0
        
        switch state {
        case .Blinking:
            return animaArray[3][0]
        case .Searching:
            randomNum = Int.random(in: 0...1)
            return animaArray[4][randomNum]
        case .Dictation:
            randomNum = Int.random(in: 0...1)
            return animaArray[6][randomNum]
        case .PairSearching:
            randomNum = Int.random(in: 0...1)
            return animaArray[7][randomNum]
            
        case .Success:
            return animaArray[5][0]
            
        case .Idle:
            randomNum = Int.random(in: 0...4)
            return animaArray[0][randomNum]
        case .Active:
            randomNum = Int.random(in: 0...3)
            return animaArray[1][randomNum]
        default:
            randomNum = Int.random(in: 0...2)
            return animaArray[2][randomNum]
            
        }
        
    }
    
    private func buildAtlas(state:WatchStates, animaSet:(FacingDirection, Int)) -> [SKTexture] {
        
        let characterAtlas = SKTextureAtlas(named: "\(state.rawValue)\(animaSet.0.rawValue)_\(animaSet.1)")
        var frams:[SKTexture] = []
        
        let numImages = characterAtlas.textureNames.count - 1
        
        for i in 0...numImages {
            let textureName = "\(i)"
            frams.append(characterAtlas.textureNamed(textureName))
        }
        return frams
    }

    
    override func sceneDidLoad() {
        
        self.size = CGSize(width: 324, height: 394)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.43)
        addChild(characterNode)
        backgroundColor = .clear
        
//        requestTextures = buildAtlas(state: .Initial, animaSet: (.Front, 1))
//        
//        animaLength = TimeInterval(Double(requestTextures.count) / 12.0)
//        
//        characterNode.run({ SKAction.animate(with: requestTextures, timePerFrame: 1.0 / 12.0)} (), withKey: animaActionKey)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let deltaTime = currentTime - elapsedTime
        
        // only update after finishing requested anima
        if deltaTime < animaLength { return }
        
        switchingState()
        print("\(requestState)")
        
        requestAnimaSet(requestState)
        
        let action = { SKAction.animate(with: requestTextures, timePerFrame: 1.0 / 12.0)} ()
        
        characterNode.removeAction(forKey: animaActionKey)
        characterNode.run(action, withKey: animaActionKey)
        
        elapsedTime = currentTime
        
        
    }
}
