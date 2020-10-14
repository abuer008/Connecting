//
//  GlobalStatisticView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI

struct GlobalStatisticView: View {
    var body: some View {
        VStack {
            Spacer()
            ZStack {
//                Color.white.opacity(0.1)
                List(0..<2) { item in
                    StatisticView()
                        .padding(.vertical, -6)
                }
//                .offset(y: 3)
                .padding(.top, 47)
                .padding(.bottom, 37)
                .listStyle(CarouselListStyle())
                
                HStack {
                    Spacer()
                    VStack {
                        TitleView()
                            .background(Color.secondary.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        Spacer()
                    }
                }
                
//                VStack {
//                    Spacer()
//                    Color.secondary.opacity(0.3)
//                        .frame(width: .infinity, height: 24, alignment: .center)
//                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GlobalStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalStatisticView()
    }
}
