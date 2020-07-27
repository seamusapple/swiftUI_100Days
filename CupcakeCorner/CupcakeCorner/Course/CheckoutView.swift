//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Ramsey on 2020/6/15.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

enum AlertType {
    case confirmation
    case error
}

struct CheckoutView: View {
    
//    @ObservedObject var order: Order
    @ObservedObject var observedOrder: ObservableOrder
    
    @State private var confirmationMessage = ""
    @State private var showingAlert = false
    @State private var alertType = AlertType.confirmation
    @State private var errorMessage = ""
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(self.observedOrder.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            switch alertType {
            case .confirmation:
                return Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            case .error:
                return Alert(title: Text("Oops!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(observedOrder.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.show(error: "Your order is failed")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(OrderStruct.self, from: data) {
                self.show(confirmation: "Your order for \(decodedOrder.quantity)x \(OrderStruct.types[decodedOrder.type].lowercased()) cupcakes is on its way!")
            } else {
                self.show(error: "Your order is failed")
                print("Invalid response from server")
            }
        }.resume()
    }
    
    func show(error: String) {
        self.errorMessage = error
        self.alertType = .error
        self.showingAlert = true
    }

    func show(confirmation: String) {
        self.confirmationMessage = confirmation
        self.alertType = .confirmation
        self.showingAlert = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(observedOrder: ObservableOrder(order: OrderStruct()))
    }
}
