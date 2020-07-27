//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Ramsey on 2020/6/16.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        switch rating {
        case 1:
            return Text("😢")
                    .opacity(0.8)
        case 2:
            return Text("😧")
                    .opacity(0.8)
        case 3:
            return Text("😲")
                    .opacity(0.8)
        case 4:
            return Text("😊")
                    .opacity(0.8)
        default:
            return Text("😀")
                    .opacity(0.8)
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
