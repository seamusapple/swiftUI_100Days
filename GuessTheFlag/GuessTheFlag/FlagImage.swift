//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Ramsey on 2020/5/27.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    let imageName: String
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(imageName: "")
    }
}
