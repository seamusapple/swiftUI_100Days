//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Ramsey on 2020/6/15.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    
//    @ObservedObject var order: Order
    @ObservedObject var observedOrder: ObservableOrder
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $observedOrder.order.name)
                TextField("Street Address", text: $observedOrder.order.streetAddress)
                TextField("City", text: $observedOrder.order.city)
                TextField("Zip", text: $observedOrder.order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(observedOrder: observedOrder)) {
                    Text("Check out")
                }
            }
            .disabled(observedOrder.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(observedOrder: ObservableOrder(order: OrderStruct()))
    }
}
