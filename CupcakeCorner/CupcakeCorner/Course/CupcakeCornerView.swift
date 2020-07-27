//
//  CupcakeCornerView.swift
//  CupcakeCorner
//
//  Created by Ramsey on 2020/6/15.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct CupcakeCornerView: View {
    
//    @ObservedObject var order = Order()
    @ObservedObject var observedOrder = ObservableOrder(order: OrderStruct())

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $observedOrder.order.type) {
                        ForEach(0..<OrderStruct.types.count, id: \.self) {
                            Text(OrderStruct.types[$0])
                        }
                    }
                    
                    Stepper(value: $observedOrder.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(observedOrder.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $observedOrder.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if observedOrder.order.specialRequestEnabled {
                        Toggle(isOn: $observedOrder.order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $observedOrder.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(observedOrder: observedOrder)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct CupcakeCornerView_Previews: PreviewProvider {
    static var previews: some View {
        CupcakeCornerView()
    }
}
