//
//  SettingView.swift
//  Flashzilla
//
//  Created by Ramsey on 2020/7/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var allowRestackForWrongAnswer: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $allowRestackForWrongAnswer) {
                        Text("Restack after wrong answer")
                    }
                }
                .navigationBarTitle("Settings")
                .navigationBarItems(trailing: Button("Done", action: dismiss))
                .listStyle(GroupedListStyle())
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(allowRestackForWrongAnswer: Binding.constant(false))
    }
}
