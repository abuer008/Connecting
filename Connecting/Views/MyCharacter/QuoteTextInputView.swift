//
//  QuoteTextInputView.swift
//  Connecting
//
//  Created by bowei xiao on 25.09.20.
//

import SwiftUI

struct QuoteTextInputView: View {
    @State private var generalString:String = "General"
    @State private var busyString:String = "when you are Busy"
    @State private var playfulString:String = "Playful"
    
    @State private var orangeColor:Color = Color("blueIdleTop")
    @State private var purpleColor:Color = Color("blueActiveTop")
    @State private var blueColor:Color = Color("blueSleepyTop")
    
    var body: some View {
        VStack {
            TextFieldView(saySomethingString: $generalString, backgroundColor: $orangeColor)
                .padding(.top, 30)
            TextFieldView(saySomethingString: $busyString, backgroundColor: $purpleColor)
            TextFieldView(saySomethingString: $playfulString, backgroundColor: $blueColor)
            Spacer()
        }

    }
}

struct QuoteTextInputView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteTextInputView()
    }
}

struct TextFieldView: View {
    @Binding var saySomethingString:String
    @Binding var backgroundColor:Color
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Say somthing ")
                        .foregroundColor(.secondary)
                    Text(saySomethingString)
                        .font(.headline)
                        .bold()
                }
                .padding(.horizontal, 80)
                Spacer()
            }
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding()
                
                .frame(width: 250, height: 55, alignment: .center)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
        .padding(.vertical, 25)
    }
}
