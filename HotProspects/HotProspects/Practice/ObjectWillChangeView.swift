//
//  ObjectWillChangeView.swift
//  HotProspects
//
//  Created by Ramsey on 2020/7/9.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }

    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ObjectWillChangeView: View {
    @ObservedObject var updater = DelayedUpdater()
    var body: some View {
        Text("Value is: \(updater.value)")
    }
}

struct ObjectWillChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectWillChangeView()
    }
}
