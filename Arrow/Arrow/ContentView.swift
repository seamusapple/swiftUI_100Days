//
//  ContentView.swift
//  Arrow
//
//  Created by Ramsey on 2020/6/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var arrowLineThickness: CGFloat = 1
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ArrowShape()
                .stroke(Color.blue, style: StrokeStyle(lineWidth: self.arrowLineThickness, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 300)
            
            Button("Border width") {
                withAnimation {
                    self.arrowLineThickness = self.arrowLineThickness == 1 ? 20 : 1
                }
            }
            .padding()
            
            Spacer()
            
            ColorCyclingRectangle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycle)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ArrowShape: InsettableShape {
    var rectangleWidth: CGFloat = 40
    var triangleBase: CGFloat = 150
    
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Triangle
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX-triangleBase/2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX-rectangleWidth/2, y: rect.midY))
        
        // Rectangle
        path.addLine(to: CGPoint(x: rect.midX-rectangleWidth/2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX+rectangleWidth/2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX+rectangleWidth/2, y: rect.midY))

        // Triangle
        path.addLine(to: CGPoint(x: rect.midX+triangleBase/2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arrow = self
        arrow.insetAmount += amount
        return arrow
    }
}
