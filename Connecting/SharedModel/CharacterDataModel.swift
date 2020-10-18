//
//  CharacterDataModel.swift
//  Connecting
//
//  Created by bowei xiao on 18.09.20.
//

import SwiftUI
import SpriteKit

// MARK: CharacterModel + DataType

enum CharacterState: String, Hashable {
    case Idle
    case Active
    case Sleepy
}

enum ColorSet: Hashable {
    case orange
    case purple
    case blue
}

// MARK: Character Data Model

struct Character:Identifiable, Hashable {
//    static func == (lhs: Character, rhs: Character) -> Bool {
//        return lhs.id == rhs.id
//    }
    // for identity the individual character data
    var id = UUID()
    // the name of character
    var name:String
    
    // the quotes of different state
    var stateName:[CharacterState:String]
    
    var scene:SKScene
    var characterState:CharacterState
    var colorSet:ColorSet
    
    // The auto generated properties
    var backgroundColor:[String] {
        convenientFuncs.getBackgroundColor(state: self.characterState, color: self.colorSet)
    }
    
    var characterColor:(Double, Double) {
        convenientFuncs.getCharacterColor(color: self.colorSet)
    }
    
    var voiceStorage:[VoiceModel]
}

// MARK: Voice Data Model

struct VoiceModel: Identifiable, Hashable {
    var id = UUID()
    
    // receiving data or sending data
    var isSource:Bool
    
    // voice data storage, temporary set to Int for mock
    var voiceClip:Int
    
    // the time that moment receiving voice data
    var timeStample:Date
    
    // the length of voice clip
    var voiceDuration:TimeInterval
    
}

// MARK: Touch Data Model

struct TouchModel {
    // the duration of touch
    var duration:Double
    
    // when happens
    var timeStampe:Date
    
    var message:[String: Any] {
        return ["TouchDuration": duration, "TouchStampe": timeStampe]
    }
}

// MARK: Convenient Functions for generate color set
class convenientFuncs {
    static func getBackgroundColor(state:CharacterState, color:ColorSet) -> [String] {
        switch state {
        case .Idle:
            switch color {
            case .orange:
                return ["orangeIdleTop", "orangeIdleBottom"]
            case .purple:
                    return ["purpleIdleTop", "purpleIdleBottom"]
            default:
                return ["blueIdleTop", "blueIdleBottom"]
            }
        case .Active:
            switch color {
            case .orange:
                return ["orangeActiveTop", "orangeActiveBottom"]
            case .purple:
                return ["purpleActiveTop", "purpleActiveBottom"]
            default:
                return ["blueActiveTop", "blueActiveBottom"]
            }
        default:
            switch color {
            case .orange:
                return ["orangeSleepyTop", "orangeSleepyBottom"]
            case .purple:
                return ["purpleSleepyTop", "purpleSleepyBottom"]
            default:
                return ["blueSleepyTop", "blueSleepyBottom"]
            }
        }
    }
    
    static func getCharacterColor(color:ColorSet) -> (Double, Double) {
        switch color {
        case .orange:
            return (0.0, 1.0)
        case .purple:
            return (225.0, 1.5)
        default:
            return (190.0, 1.7)
        }
    }
}




class mockVoiceData {
    var mockData:[VoiceModel] = []
    // store list of date for preperation of voices
    var dateList:[Date] = []
    var mockList:[VoiceModel] = []
    
    
    func generateMockDate(_ ix:Int) -> [VoiceModel] {
        
        
        let listDate = [
            [[2020, 10, 22, "GMT", 8, 22], [2020, 10, 22, "GMT", 9, 22], [2020, 10, 22, "GMT", 11, 42]],
            [[2020, 10, 20, "JST", 12, 41], [2020, 10, 22, "JST", 21, 41]],
            [[2020, 9, 27, "GMT", 15, 32], [2020, 9, 30, "GMT", 12, 21], [2020, 10, 1, "GMT", 12, 50]]
        ]
        
        for date in listDate[ix] {
            
            var components = DateComponents()
            components.year = date[0] as? Int
            components.month = date[1] as? Int
            components.day = date[2] as? Int
            components.timeZone = TimeZone(abbreviation: date[3] as! String)
            components.hour = date[4] as? Int
            components.minute = date[5] as? Int
            
            let calendar = Calendar.current
            dateList.append(calendar.date(from: components) ?? Date())
        }
        return generateMockVoices(dateList: self.dateList)
    }
    
    func generateMockVoices(dateList:[Date]) -> [VoiceModel] {
        let SourceRandom:Set<Bool> = [true, false]
        for date in dateList {
            mockList.append(VoiceModel(isSource: Array(SourceRandom)[0], voiceClip: (3..<14).randomElement()!, timeStample: date, voiceDuration: TimeInterval((3..<14).randomElement()!)))
        }
        
        return mockList
    }
    
    init(_ digit:Int) {
        self.mockData = generateMockDate(digit)
    }
}

// MARK: Mock Data
#if os(iOS)
var mockCharacters: [Character] = [
    Character(name: "Lorenz", stateName: [.Idle: "I'm calm, blar blar blar...", .Active: "Working right now", .Sleepy: "em, em, em"], scene: PrototypeScene(), characterState: .Idle, colorSet: .orange, voiceStorage: mockVoiceData(0).mockData),
    Character(name: "Andrela", stateName: [.Active: "Working right now"], scene: PrototypeScene(), characterState: .Active, colorSet: .blue, voiceStorage: mockVoiceData(1).mockData),
    Character(name: "Alex", stateName: [.Sleepy: "em, em, em"], scene: PrototypeScene(), characterState: .Sleepy, colorSet: .purple, voiceStorage: mockVoiceData(2).mockData)
]
#endif

extension Array where Element: Equatable {
    mutating func move(_ element: Element, to newIndex:Index) {
        if let oldIndex:Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex)}
    }
}

extension Array {
    mutating func move(from oldIndex:Index, to newIndex:Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
