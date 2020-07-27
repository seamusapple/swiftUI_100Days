//
//  SizeClass.swift
//  Bookworm
//
//  Created by Ramsey on 2020/6/16.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct SizeClass: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .compact {
            return AnyView(VStack {
                Text("Active size class:")
                Text("COMPACT")
            }
            .font(.largeTitle))
        } else {
            return AnyView(HStack {
                Text("Active size class:")
                Text("REGULAR")
            }
            .font(.largeTitle))
        }
    }
}

struct SizeClass_Previews: PreviewProvider {
    static var previews: some View {
        SizeClass()
    }
}
