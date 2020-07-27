//
//  TimerView.swift
//  Flashzilla
//
//  Created by Ramsey on 2020/7/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var body: some View {
        VStack {
            Text("Hello, World background!")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("Moving to the background!")
                }
            Text("Hello, World foreground!")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("Moving back to the foreground!")
            }
            Text("Hello, World screenshot!")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                    print("User took a screenshot!")
                }
        }
//        Text("Hello, World!")
//            .onReceive(timer) { time in
//                if self.counter == 5 {
//                    self.timer.upstream.connect().cancel()
//                } else {
//                    print("The time is now \(time)")
//                }
//
//                self.counter += 1
//            }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
