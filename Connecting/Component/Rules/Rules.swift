//
//  Rules.swift
//  Connecting
//
//  Created by bowei xiao on 28.09.20.
//

import GameplayKit

enum Fact:String {
    case facing = "facing"
    
    case indexShuffled = "indexSchuffled"
    case indexUniform = "indexUniform"
    case indexLinear = "indexLinear"
    
    case sameDirection = "sameDirection"
    case newDirection = "newDirection"
}

class BasicRule: GKRule {
    var settings: Settings!
    
    func grade() -> Float { return 0.5 }
    
    let fact: Fact
    
    init(fact: Fact) {
        self.fact = fact
        
        super.init()
        
        salience = Int.max
    }
    
    override func evaluatePredicate(in system: GKRuleSystem) -> Bool {
        settings = (system.state["settings"] as! Settings)
        
        if grade() >= 0.0 { return true}
        
        return false
    }
    
    override func performAction(in system: GKRuleSystem) {
        system.assertFact(fact.rawValue as NSObject, grade: grade())
    }
}

class FacingRule: BasicRule {
    override func grade() -> Float {
        let randomSource = GKARC4RandomSource()
        let randomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(settings.characteristicValue * 10), deviation: 3)
        return max(0.0, Float(randomFactor.nextInt() / 10))
    }
    
    init() {
        super.init(fact: .facing)
    }
}

class indexShuffledRule: BasicRule {
    override func grade() -> Float {
        let randomSource = GKARC4RandomSource()
        let randomFactor = GKGaussianDistribution(randomSource: randomSource, mean: Float(settings.attributeValue * 10), deviation: 3)
        let predictDigit = randomFactor.nextInt()
        
        if predictDigit <= 3 {
            return max(0.0, Float(predictDigit))
        } else if predictDigit > 3 && predictDigit < 6 {
            return min(Float(predictDigit), 5.0)
        } else {
            return max(6.0, Float(predictDigit))
        }
    }
    
    init() {
        super.init(fact: .indexShuffled)
    }
}
