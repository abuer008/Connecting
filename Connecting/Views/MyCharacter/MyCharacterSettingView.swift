//
//  MyCharacterView.swift
//  Connecting
//
//  Created by bowei xiao on 15.09.20.
//

import SwiftUI

struct MyCharacterSettingView: View {
    
    @State var characteristicValue:Double = UserDefaults.standard.double(forKey: "Characteristic")
    @State var attributeValue:Double = UserDefaults.standard.double(forKey: "Attribute")
    @State var personalityValue:Double = UserDefaults.standard.double(forKey: "Personality")
    
    
    var body: some View {
        VStack {
            
//            Text(String(UserDefaults.standard.double(forKey: "Characteristic")))
            
            CharacterSettingView(settingValue: $characteristicValue, valueRange: 0.3...0.7, accentColor: .orange, settingTitle: "Characteristic", settingText1: "Calm", settingText2: "Active")
                .onChange(of: characteristicValue) { value in
                    UserDefaults.standard.setValue(value, forKey: "Characteristic")
                }
//            Text(String(characteristicValue))
            
            CharacterSettingView(settingValue: $attributeValue, valueRange: 0.1...0.9, accentColor: .yellow, settingTitle: "Attribute", settingText1: "Masculine", settingText2: "Femine")
                .onChange(of: attributeValue, perform: { value in
                    UserDefaults.standard.setValue(value, forKey: "Attribute")
                })
//            Text(String(attributeValue))
            
            CharacterSettingView(settingValue: $personalityValue, valueRange: 0.3...0.7, accentColor: .green, settingTitle: "Personality", settingText1: "Flexible", settingText2: "Stable")
                .onChange(of: personalityValue, perform: { value in
                    UserDefaults.standard.setValue(personalityValue, forKey: "Personality")
                })
//            Text(String(personalityValue))
            
        }
        .frame(height: 450, alignment: .center)
    }
}

struct MyCharacterSettingView_Previews: PreviewProvider {
    static var previews: some View {
        MyCharacterSettingView()
    }
}

struct CharacterSettingView: View {
    
    @Binding var settingValue:Double
    var valueRange:ClosedRange<Double>
    let accentColor:Color
    let settingTitle:String
    let settingText1:String
    let settingText2:String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(settingTitle)
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }.padding(.vertical, 5)
                HStack {
                    Text(settingText1)
                    Spacer()
                    Text(settingText2)
                }.font(.subheadline)
            }
            
            Slider(value: $settingValue, in: valueRange)
                .accentColor(accentColor)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
    }
}
