//
//  ContentViewInfo.swift
//  TestTifo
//
//  Created by Guillaume on 26/05/2022.
//

import SwiftUI

struct ContentViewInfo: View {
    var nameImage:String
    var info: String
    
    var body: some View {
        HStack {
            Image(systemName: nameImage)
                .padding(5)
                .background(.white)
                .cornerRadius(10)
                .foregroundColor(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            Text(info)
                .font(.bold(.headline)())
                //.padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentViewInfo_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewInfo(nameImage: "book", info: "Information")
    }
}
