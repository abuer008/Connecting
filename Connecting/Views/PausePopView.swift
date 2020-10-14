//
//  PausePopView.swift
//  Connecting
//
//  Created by bowei xiao on 11.10.20.
//

import SwiftUI

struct PausePopView: View {
    @Binding var isPausePopUp:Bool
    @Binding var startPause:Bool
    
    @State private var countDownTimer:TimeInterval = 0.0
    
    @State var pauseTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func calculCountdownTimer(inputTime:Date) {
        let bias = inputTime.timeIntervalSinceNow
        guard bias > 0 else { return }
//        countDownTimer = bias
        
        countDownTimer = DateInterval(start: Date(), end: inputTime).duration.rounded()
    }
    
    func debugDisplayTime(inputTime:Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss"
        return df.string(from: inputTime)
    }
    
    /// functions
    
    func convertTimer(inputTimeInterval:TimeInterval) -> String {
        var secString:String = ""
        var minString:String = ""
        
        let intSeconds = Int(inputTimeInterval)
        let dSeconds:Int = intSeconds % 60
        let dMinutes:Int = Int(intSeconds / 60)
        
        if dSeconds < 10 { secString = "0\(dSeconds)" } else { secString = String(dSeconds) }
        if dMinutes < 10 { minString = "0\(dMinutes)" } else { minString = String(dMinutes) }
        
        return "\(minString):\(secString)"
        
    }
    
    var body: some View {
        VStack {
            // debugging...
//                Text("selectTime: \(debugDisplayTime(inputTime: pauseTime))")
            
            VStack {
                HStack {
                    Text("Pause monitoring")
                        .bold()
                        .padding(.leading)
                    Spacer()
                    Text(convertTimer(inputTimeInterval: countDownTimer))
//                        .bold()
                        .onReceive(timer, perform: { _ in
                            if countDownTimer > 0 {
                                withAnimation(.spring()) {
                                countDownTimer -= 1
                                }
                            } else {
                                countDownTimer = 0.0
                            }
                        })
                        .padding(.trailing)
                }
                .font(.title3)
                .padding(.top, 10)
                Divider()
                    .offset(y: -10)
                Spacer()
                
                VStack {
                    
                    Image(systemName: "arrowtriangle.up.fill")
                        .padding(.trailing)
                        .opacity(0.5)
                    HStack {
                        Text("Until")
                            .font(.title3)
                            .bold()
                            .padding(.leading, 20)
                        DatePicker("", selection: $pauseTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(.white)
                            .padding(.trailing)
                    }
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .padding(.trailing)
                        .opacity(0.5)
                }
                .padding(.bottom, 25)
            }
            .foregroundColor(.white)
            .frame(width: 271, height: 180, alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: [Color("characterRedTop").opacity(0.65), Color("characterRedBottom").opacity(0.65)]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color("characterRedBottom"), radius: 30, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 8.0)
            
            HStack {
                Button(action: {
                    withAnimation(.spring()) { self.isPausePopUp = false }
                    self.countDownTimer = 0.0
                    self.startPause = false
                }, label: {
                    Text("Cancel")
                        .frame(width: 131, height: 50, alignment: .center)
                        .background(Color.secondary.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                })
                Button(action: {
                        withAnimation(.spring()) {
                            self.isPausePopUp = false
                        }
                    self.calculCountdownTimer(inputTime: pauseTime)
                    if self.countDownTimer > 0 { self.startPause = true }
                }, label: {
                    Text("Pause")
                        .frame(width: 131, height: 50, alignment: .center)
                        .background(Color("characterRedBottom"))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                })
                .buttonStyle(BorderlessButtonStyle())
            }
            .foregroundColor(.white)
        }
    }
}

struct PausePopView_Previews: PreviewProvider {
    static var previews: some View {
        PausePopView(isPausePopUp: .constant(true), startPause: .constant(false))
    }
}
