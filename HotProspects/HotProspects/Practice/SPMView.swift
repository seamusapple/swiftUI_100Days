//
//  SPMView.swift
//  HotProspects
//
//  Created by Ramsey on 2020/7/9.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import SamplePackage

struct SPMView: View {
    let possibleNumbers = Array(1...60)
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
    
    var body: some View {
        Text(results)
    }
}

struct SPMView_Previews: PreviewProvider {
    static var previews: some View {
        SPMView()
    }
}
