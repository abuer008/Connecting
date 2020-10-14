//
//  AnimationComponent.swift
//  Connecting
//
//  Created by bowei xiao on 10.09.20.
//

import SpriteKit
import GameplayKit

enum AnimationState: String {
    // The states about interact relatet
    case pending = "Pending"
    case pair = "Pair"
    case touch = "Touch"
    case voice = "Voice"
    case statistic = "Statistic"
    case success = "Success"
    
    // The states about autonomous animation
    case idle = "Idle"
    case active = "Active"
    case sleepy = "Sleepy"
    
}

enum FacingDirection:Int {
    case front = 0, side
}

enum ClipsIndex:Int {
    case first = 1, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, elfth, twelwth, thirdteenth
    
    static let allIndex: [ClipsIndex] = [.first, .second, .third, .fourth, .fifth, .sixth, .seventh, .eighth, .ninth, .tenth, .elfth, .twelwth, .thirdteenth]
    
    init(index: Int) {
        switch index {
        case 1:
            self = .first
        case 2:
            self = .second
        case 3:
            self = .third
        case 4:
            self = .fourth
        case 5:
            self = .fifth
        case 6:
            self = .sixth
        case 7:
            self = .seventh
        case 8:
            self = .eighth
        case 9:
            self = .ninth
        case 10:
            self = .tenth
        case 11:
            self = .elfth
        case 12:
            self = .twelwth
        case 13:
            self = .thirdteenth
        default:
            fatalError("(AnimationComponent - ClipsIndex): Unsupport ClipIndex")
        }
    }
}

struct Clip {
    // MARK: Porperties
    
    /// three main catalog for this clip
    let animationState: AnimationState
    let facingDirection: FacingDirection
    let index: ClipsIndex
    
    /// contents of clip
    let textures:[SKTexture]
    var frameOffset = 0
    let isRepeatClip:Bool
    
}

class AnimationComponent: GKComponent {
    
    // MARK: Porperties
    /// static porperties
    static let bodyActionKey = "bodyAction"
    
    static let textureActionKey = "textureAction"
    
    static let timePerframe = TimeInterval(1.0 / 12.0)
    
    var timeSinceUpdate:TimeInterval = 0.0
    
    /// The animation state not play yet
    var requestedAnimationState: AnimationState?
    
    /// The node run animations
    let node: SKSpriteNode
    
    /// The current set of animations for entity
//    var animations: [AnimationState: [FacingDirection: [ClipsIndex: Clip]]]
    
    /// requested index of Clips
    
//    let clipsIndex: ClipsIndex
    
    private(set) var currentClips: [Clip]?
    
    private var elapsedClipDuration: TimeInterval = 0.0
    
    // MARK: Initialisation
    
    init(textureSize:CGSize) {
        node = SKSpriteNode(texture: nil, size: textureSize)
        
//        self.animations = animations
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Convenient functions

extension AnimationComponent {
    // convenient function for find the last clip in the clip set
    
//    func findLastIndexOfClips(clip: Clip) -> Clip {
//        let nextIndex = clip.index.rawValue + 1
//        
//        guard let nextClip = animations[clip.animationState ]?[clip.facingDirection]?[ClipsIndex(index: nextIndex)] else {
//            
//            return animations[clip.animationState]?[clip.facingDirection]?[ClipsIndex(index: (nextIndex - 1))] ?? clip
//            
//        }
//        
//        return findLastIndexOfClips(clip: nextClip)
//    }
    
    // convenient function for combine the multiple textures
    
    func combineClips(arrayTextures textures: [[SKTexture]]) -> [SKTexture] {
        
        var newCombineTextures: [SKTexture] = []
        for texture in textures {
            newCombineTextures.append(contentsOf: texture)
        }
        return newCombineTextures
    }
    
    private func generateFacingDirection(randomSource:GKRandomSource) -> FacingDirection {
        
        let characteristicValue = UserDefaults.standard.double(forKey: "Characteristic")
        let characteristicRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(characteristicValue * 10), deviation: 3)
        let gradeForCharacteristic = Double(characteristicRandomFactor.nextInt() / 10)
        
        if gradeForCharacteristic < 0.5 {
            return adjustFacingDirection(randomSource: randomSource, facingDirection: .front)
        } else {
            return adjustFacingDirection(randomSource: randomSource, facingDirection: .side)
        }
    }
    
    private func adjustFacingDirection(randomSource:GKRandomSource, facingDirection:FacingDirection) -> FacingDirection {
        
        let personalityValue = UserDefaults.standard.double(forKey: "Personality")
        let personalityRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(personalityValue * 10), deviation: 3)
        let gradeForPersonality = Double(personalityRandomFactor.nextInt() / 10)
        
        if gradeForPersonality < 0.5 {
            if currentClips?[0].facingDirection != nil && facingDirection != currentClips?[0].facingDirection {
                return currentClips![0].facingDirection
            }
        } else {
            return currentClips?[0].facingDirection == .front ? .side : .front
        }
        return .front
    }
    
    private func findNumberOfIndex(_ animationState: AnimationState, _ facingDirection: FacingDirection) -> Int {
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
    
    private func generateRandomIndex(animationState:AnimationState, facingDirection:FacingDirection) -> ClipsIndex {
        let randomSource:GKRandomSource = GKARC4RandomSource()
        let numberOfIndex = findNumberOfIndex(animationState, facingDirection)
        
        let attributeValue = UserDefaults.standard.double(forKey: "Attribute")
        let attributeRandomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(attributeValue * 10), deviation: 3)
        let gradeForAttribute = Double(attributeRandomFactor.nextInt() / 10)
        
        if gradeForAttribute <= 0.3 {
            let randomIndex = GKShuffledDistribution(lowestValue: 1, highestValue: numberOfIndex)
            return ClipsIndex(index: randomIndex.nextInt())
        } else if gradeForAttribute >= 0.6 {
            let randomIndex = GKRandomDistribution(randomSource: GKLinearCongruentialRandomSource(), lowestValue: 1, highestValue: numberOfIndex)
            return ClipsIndex(index: randomIndex.nextInt())
        } else {
            let randomIndex = GKRandomDistribution(randomSource: randomSource, lowestValue: 1, highestValue: numberOfIndex)
            return ClipsIndex(index: randomIndex.nextInt())
        }
    }
    
    private func loadResources(state:AnimationState, facing:FacingDirection, index:ClipsIndex) -> [Clip] {
//        let handyAtlasNames = [
//            "H_IdleFront",
//            "H_IdleSide",
//            "H_ActiveFront",
//            "H_ActiveSide",
//            "H_SleepyFront",
//            "H_SleepySide"
//        ]
        
        var foundClips:[Clip] = []
        let AtlasNames:[String]
        
        switch state {
        case .idle:
            switch facing {
            case .front:
                AtlasNames = ["H_IdleFront_\(index.rawValue)"]
            default:
                AtlasNames = ["H_IdleSide_\(index.rawValue)", "H_IdleSide_1", "H_IdleSide_\(findNumberOfIndex(.idle, .side))"]
            }
        case .active:
            switch facing {
            case .front:
                AtlasNames = ["H_ActiveFront_\(index.rawValue)"]
            default:
                AtlasNames = ["H_ActiveSide_\(index.rawValue)",
                              "H_ActiveSide_1", "H_ActiveSide_\(findNumberOfIndex(.active, .side))"]
            }
        default:
            switch facing {
            case .front:
                AtlasNames = ["H_SleepyFront_\(index.rawValue)"]
            default:
                AtlasNames = ["H_SleepySide_\(index.rawValue)", "H_SleepySide_1", "H_SleepySide_\(findNumberOfIndex(.sleepy, .side))"]
            }
        }
        
        SKTextureAtlas.preloadTextureAtlasesNamed(AtlasNames) {
            error, characterAtlas in
            if let error = error {
                fatalError("(OwlCharacter: preloadTextureAtlases): One or more texture atlases could not be found: \(error).")
            }
            
            
            if characterAtlas.count == 1 {
                let textures = characterAtlas[0].textureNames.sorted {
                    $0 < $1
                }.map { characterAtlas[0].textureNamed($0) }
                
                foundClips.append(Clip(animationState: state, facingDirection: facing, index: index, textures: textures, isRepeatClip: false))
                
            } else {
                for atlas in characterAtlas {
                    let textures = atlas.textureNames.sorted {
                        $0 < $1
                    }.map { atlas.textureNamed($0) }
                    
                    foundClips.append(Clip(animationState: state, facingDirection: facing, index: index, textures: textures, isRepeatClip: false))
                }
            }
        }
        return foundClips
    }
}


// MARK: Character Animation
extension AnimationComponent {
    
    // run clip base on state, facing direction and index
    private func runClipForAnimationStateAndClipsIndex(animationState:AnimationState,deltaTime:TimeInterval) {
        
        elapsedClipDuration += deltaTime
        
        let combineTextures: [SKTexture]
        var facingDirection: FacingDirection
        var indexOfClips:ClipsIndex
        
        // randomise facingDirection and indexOfClips
        let characteristicRandomSource = GKARC4RandomSource()
        
        /// characterValue from user
        /// personalityValue from user
        facingDirection = generateFacingDirection(randomSource: characteristicRandomSource)
        
        
        /// attributeValue from user
        indexOfClips = generateRandomIndex(animationState: animationState, facingDirection: facingDirection)
        
        /// loadResources
        let clips = loadResources(state: animationState, facing: facingDirection, index: indexOfClips)
        
        guard clips != nil else { fatalError("loading clips do not success") }
        
        // the last clip based on request
        let lastClipOfClipSet: Clip
        
        if currentClips != nil && currentClips![0].animationState == animationState && currentClips![0].facingDirection == facingDirection {
            // do somthing if request the same clip
        }
        
        /*
         based on the requested clip autonomous generated 3 clip
         1. the original requested clip
         2. the first clip in the requested clip set (same AnimationState and FacingDirection )
         3. the last clip in the requested clip set
         */
        
        // the requested clip
        
//        guard let unwrappedClip = animations[animationState]?[facingDirection]?[indexOfClips] else { print("(AnimationComponent runClipForAnimationStateAndClipsIndex): Unknown clip for state \(animationState.rawValue), facing \(facingDirection.rawValue), index \(indexOfClips.rawValue)")
//            return
//        }
//
//        let clip = unwrappedClip
        
        
        // the first clip based on request
//        guard let firstOfUnwrappedClip = animations[animationState]?[facingDirection]?[ClipsIndex.first] else {
//            print("(AnimationComponent runClipForAnimationStateAndClipsIndex): Unknown clip for state \(animationState.rawValue), facing \(facingDirection.rawValue), index \(indexOfClips.rawValue).")
//            return
//        }
//        let firstClipOfClipSet = firstOfUnwrappedClip
        
        /* */
        
        // bodyAction
//        if currentClip?.bodyActionName != clip.bodyActionName {
//            node.removeAction(forKey: AnimationComponent.bodyActionKey)
//
//            node.position = .zero
//
//            if let bodyAction = clip.bodyAction {
//                node.run(SKAction.repeatForever(bodyAction), withKey: AnimationComponent.bodyActionKey)
//            }
//        }
        
        node.removeAction(forKey: AnimationComponent.textureActionKey)
        
        let texturesAction: SKAction
        
        if clips[0].textures.count == 1 {
            texturesAction = SKAction.setTexture(clips[0].textures.first!)
        } else {
            
//            switch animationState {
//            // the non-directional state
//            case .pair, .touch, .voice, .statistic:
//
//                if currentClip != nil && animationState == currentClip?.animationState {
//                    // both same state -- direct action
//
//                    if clip.isRepeatClip {
//                        texturesAction = SKAction.repeatForever(SKAction.animate(with: clip.textures, timePerFrame: AnimationComponent.timePerframe))
//                    } else {
//                        texturesAction = SKAction.animate(with: clip.textures, timePerFrame: AnimationComponent.timePerframe)
//                    }
//
//                } else {
                    // change state action, state changed -- action old last then new request first clip
                    
                    /// when don't have old clip, then combine first clip of requested clip set and requested clip
                    /// when old clip exisited, then combine last clip of old clip set and the first clip of requested clip set
//                    if let oldClips = currentClips {
//                        lastClipOfClipSet = findLastIndexOfClips(clip: oldClip)
//
//                        combineTextures = combineClips(arrayTextures: [lastClipOfClipSet.textures, firstClipOfClipSet.textures])
//                    } else {
//                        combineTextures = combineClips(arrayTextures: [firstClipOfClipSet.textures, clip.textures])
//                    }
//
//                    texturesAction = SKAction.animate(with: combineTextures, timePerFrame: AnimationComponent.timePerframe)
                    
//                }
                
            // the rest autonomous played state: idle, active, sleepy
//            default:
                
                switch facingDirection {
                case .front:
                    if currentClips != nil && facingDirection != currentClips![0].facingDirection {
                        // when the old clips direction is side -- action old last then new request clip
                        lastClipOfClipSet = currentClips![2]
                        combineTextures = combineClips(arrayTextures: [lastClipOfClipSet.textures, clips[0].textures])
                        
                        texturesAction = SKAction.animate(with: combineTextures, timePerFrame: AnimationComponent.timePerframe)
                        
                    } else {
                        // when has no old clip or both direction is front -- direct action
                        texturesAction = SKAction.animate(with: clips[0].textures, timePerFrame: AnimationComponent.timePerframe)
                    }
                default:
                    if currentClips != nil && facingDirection != currentClips?[0].facingDirection {
                        // when the old clips direction is front and new clips direction is side -- action new request first clip
                        combineTextures = combineClips(arrayTextures: [clips[1].textures, clips[0].textures])
                        
                        texturesAction = SKAction.animate(with: combineTextures, timePerFrame: AnimationComponent.timePerframe)
                    } else {
                        // the old clips direction is equal to new clips -- direct action
                        
                        texturesAction = SKAction.animate(with: clips[0].textures, timePerFrame: AnimationComponent.timePerframe)
                    }
                }
        }
        // Add the textures animation to the body node
        node.run(texturesAction, withKey: AnimationComponent.textureActionKey)
        
        // renew the old clip
        currentClips = clips
        
        // reset the time duration counter
        elapsedClipDuration = 0.0
    }
    
    // MARK: Texture loading utilities
    
    class func animationsFromAtlas(atlas: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: AnimationState, facingDirection: FacingDirection, numberOfClips indexs: ClipsIndex, bodyActionName: String? = nil, isRepeatClip: Bool = false) -> [ClipsIndex: Clip] {
        
//        let bodyAction: SKAction?
//        if let name = bodyActionName {
//            bodyAction = SKAction(named: name)
//        } else {
//            bodyAction = nil
//        }
        
        
        var animations = [ClipsIndex: Clip]()
        
        
        for index in 1...indexs.rawValue {
            
            let textures = atlas.textureNames.filter {
                $0.hasPrefix("\(identifier)_\(index)_")
            }.sorted {
                $0 < $1
            }
            .map {
                atlas.textureNamed($0)
            }
            
            animations[ClipsIndex(index: index)] = Clip(
                animationState: animationState,
                facingDirection: facingDirection,
                index: ClipsIndex(index: index),
                textures: textures,
                frameOffset: 0,
                isRepeatClip: isRepeatClip
            )
        }
        
        return animations
    }
}

// MARK: Component Life Cycle

extension AnimationComponent {
    override func update(deltaTime seconds: TimeInterval) {
        
        timeSinceUpdate += seconds
        
        if timeSinceUpdate < 10.0 { return }
        
        timeSinceUpdate = 0.0
        print("AnimationComponent updated...")
        
        guard let animationState = requestedAnimationState else { return }
        
        runClipForAnimationStateAndClipsIndex(animationState: animationState, deltaTime: seconds)
        
        requestedAnimationState = nil
    }
}
