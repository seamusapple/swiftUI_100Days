//
//  GridStack.swift
//  GuessTheFlag
//
//  Created by Ramsey on 2020/5/27.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                        .ProminentTitleStyle()
                    }
                }
            }
        }
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: 5, columns: 5, content: { (row, col) in
            Text("R\(row) C\(col)")
        })
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}

extension View {
    func ProminentTitleStyle() -> some View {
        self.modifier(ProminentTitle())
    }
}
