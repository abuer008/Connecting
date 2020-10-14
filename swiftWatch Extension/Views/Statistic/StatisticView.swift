//
//  StatisticView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI

struct StatisticView: View {
    
    let digitArray = [ 6, 12, 18, 24 ]
    
    var body: some View {
        ZStack {
            
            // background
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .foregroundColor(Color.secondary.opacity(0.1))
//                .frame(width: 153, height: 85, alignment: .center)
            
            // Statistic title
            HStack {
                VStack {
                    Text("Touch frequency")
                        .font(.caption2)
                        .padding(.horizontal, 7)
                        .padding(.top, 10)
                    Spacer()
                }
                Spacer()
            }
            
            VStack(alignment: .center) {
                ForEach((0..<3).indices, id: \.self) { ix in
                    Color.white
                        .opacity(0.2)
                        .frame(width: 135, height: 0.75, alignment: .center)
                        .padding(.top, 15)
                }
                
                HStack {
                    ForEach(digitArray.indices, id: \.self) { ix in
                        Text("\(digitArray[ix])")
                            .font(.system(size: 9))
                            .padding(.horizontal, 13)
                    }
                    .padding(.bottom, 3)
                }
                .opacity(0.3)
                .font(.system(size: 10))
                
            }
            .padding(.top, 10)
            
            StatisticDetailView()
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}

struct StatisticDetailView: View {
    
    var touchStatisticArray:[CGFloat] = [ 5, 10, 8, 7, 3, 8, 20, 15, 50, 45, 18, 32, 12, 10, 16, 13, 15, 22, 0, 0]
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(touchStatisticArray.indices, id: \.self) { index in
                Rectangle()
                    .overlay(LinearGradient(gradient: Gradient(colors: [Color("blueSleepyBottom"), Color("blueSleepyTop")]), startPoint: .bottom, endPoint: .top))
                    .frame(width: 4, height: touchStatisticArray[index], alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
        }
        .scaleEffect(0.8)
        .padding(.top, 10)
    }
}
