//
//  Keyboard.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

enum KeyboardButtonActionType {
    case number(text: String)
    case delete
    case submit
}

struct KeyboardTextStyle: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var bgColor: Color = Color.blue

    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(maxWidth: width, maxHeight: height)
            .foregroundColor(Color.white)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func keyboardTextStyle(width: CGFloat, height: CGFloat, bgColor: Color = Color.blue) -> some View {
        self.modifier(KeyboardTextStyle(width: width, height: height, bgColor: bgColor))
    }
}

struct Keyboard: View {
    var actionPerformed: ((KeyboardButtonActionType) -> ())?
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .center, spacing: 10) {
                ForEach(0...3, id: \.self) { i in
                    HStack {
                        ForEach(1...3, id: \.self) { j in
                            Button(action: {
                                self.actionPerformed?(self.getButtonActionType(index: j+i*3))
                            }) {
                                if j+i*3 == 10 {
                                    Image(systemName: "delete.left")
                                        .keyboardTextStyle(
                                            width: self.getWidth(g),
                                            height: self.getHeight(),
                                            bgColor: Color.red)
                                } else {
                                    Text(self.getButtonText(index: j+i*3))
                                        .keyboardTextStyle(
                                            width: self.getWidth(g),
                                            height: self.getHeight(),
                                            bgColor: (j+i*3 == 12) ? Color.green : Color.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getButtonActionType(index: Int) -> KeyboardButtonActionType {
        if index == 10 {
            return .delete
        } else if index == 12 {
            return .submit
        } else if index == 11 {
            return .number(text: "0")
        } else {
            return .number(text: "\(index)")
        }
    }
    
    func getButtonText(index: Int) -> String {
        if index == 12 { return "Submit"}
        if index == 11 { return "0" }
        return "\(index)"
    }
    
    func getWidth(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 3 - 10
    }

    func getHeight() -> CGFloat {
        return 50
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
