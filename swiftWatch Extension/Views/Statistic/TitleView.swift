//
//  TitleView.swift
//  swiftWatch Extension
//
//  Created by bowei xiao on 08.10.20.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lorenz")
                .font(.callout)
                .bold()
            Text("Friend")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 107, height: 44, alignment: .leading)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
