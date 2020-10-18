//
//  ConvenientFunctions.swift
//  Connecting
//
//  Created by bowei xiao on 05.10.20.
//

import SpriteKit
import GameplayKit

extension PrototypeState {
    
  func handleTouch(_ connection: SharedConnectivity, message: Double) {
    if message == 1.1 {
      stateMachine?.enter(PrototypeTouchState.self)
    }
    
  }
  
  
  func switchingStates() {
        let isPair = UserDefaults.standard.bool(forKey: "IsPair")
        let isConnect = UserDefaults.standard.bool(forKey: "IsConnect")

        if isPair && !isConnect {
            currentState = .pair
        } else if isPair && isConnect {
            currentState = .success
        } else if !isPair && !isConnect {
            currentState = .pending
        } else {
            switchAutoState()
        }
    }

    func switchAutoState() {
        currentState = .idle
    }
  
  func switchTouchState() {
    let isTouched = UserDefaults.standard.bool(forKey: "IsTouch")
    
    if isTouched {
      stateMachine?.enter(PrototypeTouchState.self)
    } else {
      return
    }
  }

    func combineTextures(arrayTextures textures: [[SKTexture]]) -> [SKTexture] {
        
        var newCombineTextures: [SKTexture] = []
        for texture in textures {
            newCombineTextures.append(contentsOf: texture)
        }
        return newCombineTextures
    }
    
    private func fetchTexturesFromAtlas(_ stateIdentifier:String, index:Int) -> [SKTexture] {
        var texturesAtlasArray:[SKTextureAtlas] = []
        var textures:[SKTexture] = []
        
        if index == 1 {
            let texturesAtlas = SKTextureAtlas(named: "H_\(stateIdentifier)Front_1")
            let texturesNum = texturesAtlas.textureNames.count - 1
            
            for i in 0...texturesNum {
                let name:String = "\(i)"
                textures.append(texturesAtlas.textureNamed(name))
            }
            
        } else {
            for atlasIndex in 1...index {
                texturesAtlasArray.append(SKTextureAtlas(named: "H_\(stateIdentifier)Front_\(atlasIndex)"))
                for atlas in texturesAtlasArray {
                    let texturesNum = atlas.textureNames.count - 1
                    
                    for i in 0...texturesNum {
                        let name:String = "\(i)"
                        textures.append(atlas.textureNamed(name))
                    }
                }
            }
        }
        
        return textures
    }
    
    func runInteractionState(state:AnimationState, node:SKNode) {
        
        // only accepted interaction state
        guard state == .pending || state == .pair || state == .statistic || state == .success || state == .touch else { fatalError("\(#function): wrony state") }
        
        var stateIdentifier:String = ""
        var requestedTexturesArray:[SKTexture] = []
        
        switch state {
        case .pending: // only have 1 clip
            stateIdentifier = "Pending"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 1)
            
        case .pair: // have 2 optional clips
            stateIdentifier = "Pair"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 2)
            
        case .success: // have 1 clip
            stateIdentifier = "Success"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 1)
            
        case .statistic: // have 1 ~ 2 clips
            stateIdentifier = "Pair"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 2)
            
        case .touch: // touch state have 3 clips
            stateIdentifier = "Touch"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 3)
            
        default:
            stateIdentifier = "Idle"
            requestedTexturesArray = fetchTexturesFromAtlas(stateIdentifier, index: 1)
            
        }
        
        guard requestedTexturesArray != [] else { return print("\(#function): no such texture set...") }
        
        var action:SKAction?
        var restTime:TimeInterval = 0.0
        
    
        action = { SKAction.repeatForever(.animate(with: requestedTexturesArray, timePerFrame: 1.0 / 12.0 ))} ()
            restTime = TimeInterval(requestedTexturesArray.count) / 12.0
        
        node.removeAction(forKey: "testAnima")
        node.run(action!, withKey: "testAnima")
        
        print("\(restTime)")
        
        UserDefaults.standard.setValue(restTime, forKey: "restTime")
    }
    
    func runClipForState(state:AnimationState, node:SKNode) {
        
        // MARK: Properties
        var restTimeInterval:TimeInterval = 0.0
        
//        if oldClips.count == 1 {
//            restTimeInterval = TimeInterval(oldClips[0].textures.count) / 12.0
//        }
        
//        var oldFacing:FacingDirection = .front
        
        /// facing direction and index are waiting for generate...
        var facingDirection:FacingDirection?
        var indexOfClip:ClipsIndex?
        
        /// default random set
        let randomSource = GKARC4RandomSource()
        
        /// store the generated textures
        var requestedTextures:[SKTexture] = []
        var requestedClips:[Clip] = []
        
        var shouldPlayLast:Bool { return UserDefaults.standard.bool(forKey: "PlayLastClip")}
        
        /// generate facing direction
        
        facingDirection = generateFacingDirection(randomSource: randomSource, oldFacing: oldFacing ? .front : .side)
        
        /// generate index
        
        if facingDirection != nil {
            indexOfClip = generateRandomIndex(animationState: state, facingDirection: facingDirection!)}
        
        /// load requested textures
        if indexOfClip != nil {
            requestedTextures = loadTextures(state, facingDirection!, indexOfClip!)
            requestedClips.append(Clip(animationState: state, facingDirection: facingDirection!, index: indexOfClip!, textures: requestedTextures, isRepeatClip: false))
            
            let oldFacingDirection:FacingDirection = oldFacing ? .front : .side
            
            if oldFacingDirection == .side && oldFacingDirection != facingDirection && shouldPlayLast {
                // old facing side and new facing front, play side last then front
                let lastClipsNum = findNumberOfIndex(state, oldFacing ? .front : .side)
                
                let firstTextures = loadTextures(state, .side, ClipsIndex(index: lastClipsNum))
                let secondTextures = loadTextures(state, facingDirection!, indexOfClip!)
                
                requestedTextures = combineTextures(arrayTextures: [firstTextures, secondTextures])
                
            } else if oldFacingDirection == .front && oldFacingDirection != facingDirection {
                // old facing front and new facing side, play new side first clip then requested clip
                
                let firstTextures = loadTextures(state, facingDirection!, .first)
                let secondTextures = loadTextures(state, facingDirection!, indexOfClip!)
                
                requestedTextures = combineTextures(arrayTextures: [firstTextures, secondTextures])
            } else {
                requestedTextures = loadTextures(state, facingDirection!, indexOfClip!)
            }
            
        }
        /// run animate
        let action = SKAction.animate(with: requestedTextures, timePerFrame: 1.0 / 12.0 )
        
        node.removeAction(forKey: "testAnima")
        node.run(action, withKey: "testAnima")
        
        let lastIndex = findNumberOfIndex(state, facingDirection!)
        
        var saveOldFacing:Bool = false
        var shouldPlayLastClip:Bool = true
        
        if facingDirection == .front { saveOldFacing = true }

        if indexOfClip == ClipsIndex(index: lastIndex) { shouldPlayLastClip = false }
        
        UserDefaults.standard.setValue(saveOldFacing, forKey: "OldFacing")
        UserDefaults.standard.setValue(shouldPlayLastClip, forKey: "PlayLastClip")
        
        restTimeInterval = TimeInterval(requestedTextures.count) / 12.0
        
        UserDefaults.standard.setValue(Double(restTimeInterval), forKey: "restTime")
    }
    
    
    
     
    func loadTextures(_ state:AnimationState, _ facing:FacingDirection, _ index:ClipsIndex) -> [SKTexture] {
        
        var tempFrams:[SKTexture] = []
        
        var identifiers:String {
            return "H_\(firstIdentifier())\(firstFacingIdentifier())_\(index.rawValue)"
        }
        
//        let numIdleFrontFrams:[Int] = [35, 31, 31, 31, 35, 36, 36, 36, 36, 24, 34, 31, 41]
//        let numIdleSideFrams:[Int] = [35, 38, 43, 59, 99, 5]
//        let numActiveFrontFrams:[Int] = []
//        let numActiveSideFrams:[Int] = []
//        let numSleepyFrontFrams:[Int] = []
//        let numSleepySideFrams:[Int] = []
        
        func firstIdentifier() -> String {
            switch state {
            case .idle:
                return "Idle"
            case .active:
                return "Active"
            default:
                return "Sleepy"
            }
        }
        
        func firstFacingIdentifier() -> String {
            switch facing {
            case .front:
                return "Front"
            default:
                return "Side"
            }
        }
        
        let requestedAtlas = SKTextureAtlas(named: identifiers)
        
        let numImages = requestedAtlas.textureNames.count - 1
        
        for i in 0...numImages {
            let textureName = "\(i)"
            tempFrams.append(requestedAtlas.textureNamed(textureName))
        }
        
        return tempFrams
    }
    
    func generateFacingDirection(randomSource:GKRandomSource, oldFacing:FacingDirection) -> FacingDirection {
        
        // read the characteristic setting
        let characteristicValue = UserDefaults.standard.double(forKey: "Characteristic")
//        print("characteristicValue = \(characteristicValue)")
        
        // characteristic value = range 0.3 ~ 0.7, random number 3 ~ 7, deviation -2 ~ 3 ~ +2
        let characteristicRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(characteristicValue * 10), deviation: 2.3)
        let gradeForCharacteristic = Double(characteristicRandomFactor.nextInt() / 10)
        
        // optional 1. prefer front direction
        if gradeForCharacteristic < 0.5 {
            return adjustFacingDirection(randomSource: randomSource, facingDirection: .front, oldFacing: oldFacing)
        } else {
            // optional 2. prefer side direction
            return adjustFacingDirection(randomSource: randomSource, facingDirection: .side, oldFacing: oldFacing)
        }
    }
    
    func adjustFacingDirection(randomSource:GKRandomSource, facingDirection:FacingDirection, oldFacing:FacingDirection) -> FacingDirection {
        var finalFacing:FacingDirection = facingDirection
        
        // read the personality setting
        let personalityValue = UserDefaults.standard.double(forKey: "Personality")
//        print("personalityValue = \(personalityValue)")
        
        // personality value = range 0.3 ~ 0.7, random number 3 ~ 7, deviation -2 ~ 3 ~ +2
        let personalityRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(personalityValue * 10), deviation: 2.3)
//        let gradeForPersonality = Double(personalityRandomFactor.nextInt() / 10)
        let comparedFactor = personalityRandomFactor.nextInt() + 2
        
        // the setting number larger than bias, force the same direction
        if comparedFactor > directionBias {
            directionBias += 1
            if facingDirection != oldFacing {
                finalFacing = oldFacing
                directionBias += 3
            }
        } else {
            // if the setting number less than bias, change the direction, then set the bias back to 0.
            if oldFacing == .front { finalFacing = .side } else { finalFacing = .front }
            directionBias = 0
        }
        return finalFacing
    }
    
    func generateRandomIndex(animationState:AnimationState, facingDirection:FacingDirection) -> ClipsIndex {
        let randomSource:GKRandomSource = GKARC4RandomSource()
        let numberOfIndex = findNumberOfIndex(animationState, facingDirection)
        var tmpIndex:ClipsIndex = .first
        
        let attributeValue = UserDefaults.standard.double(forKey: "Attribute")
//        print("AttributeValue = \(attributeValue)")
        
        let attributeRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(attributeValue * 10), deviation: 3)
        let gradeForAttribute = Double(attributeRandomFactor.nextInt() / 10)
        
        if gradeForAttribute <= 0.3 {
            let randomIndex = GKShuffledDistribution(lowestValue: 1, highestValue: numberOfIndex)
            tmpIndex = ClipsIndex(index: randomIndex.nextInt())
        } else if gradeForAttribute >= 0.6 {
            let randomIndex = GKRandomDistribution(randomSource: GKLinearCongruentialRandomSource(), lowestValue: 1, highestValue: numberOfIndex)
            tmpIndex = ClipsIndex(index: randomIndex.nextInt())
        } else {
            let randomIndex = GKRandomDistribution(randomSource: randomSource, lowestValue: 1, highestValue: numberOfIndex)
            tmpIndex = ClipsIndex(index: randomIndex.nextInt())
        }
        
        if gradeForAttribute < 0.3 {
            
            switch animationState {
            case .idle:
                tmpIndex = Bool.random() && facingDirection == .front ? .first : tmpIndex
            default:
                tmpIndex = Bool.random() && facingDirection == .front ? .second : tmpIndex
            }
            
        }
        
        return tmpIndex
    }
    
    func findNumberOfIndex(_ animationState: AnimationState, _ facingDirection: FacingDirection) -> Int {
        if facingDirection == .front {
            switch animationState {
            case .idle:
                return 13
            case .active:
                return 9
            case .sleepy:
                return 8
            default:
                return 5
            }
        } else {
            switch animationState {
            case .idle:
                return 6
            case .active:
                return 7
            case .sleepy:
                return 8
            default:
                return 5
            }
        }
    }
}
