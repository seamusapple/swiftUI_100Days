//
//  MainView.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @ObservedObject var favorites = Favorites()
    @State private var showingSortFilterPanel = false
    @State private var sortType = SortType.default
    @State var countriesSelection: [String] = ["All"]
    @State var sizesSelection: [String] = ["All"]
    @State var pricesSelection: [String] = ["All"]
    
    var sorted: [Resort] {
        switch sortType {
        case .default:
            return resorts
        case .name:
            return resorts.sorted { $0.name < $1.name }
        case .country:
            return resorts.sorted { $0.country < $1.country }
        }
    }
    
    var sortedAndFiltered: [Resort] {
        var list = sorted
        list = filteredCountries(resorts: sorted)
        list = filteredSizes(resorts: list)
        list = filteredPrices(resorts: list)
        
        return list
    }
    
    var body: some View {
        NavigationView {
            List(sortedAndFiltered) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingSortFilterPanel, content: {
                SortAndFilterView(resorts: self.resorts,
                                  sortType: self.$sortType,
                                  countriesSelection: self.$countriesSelection,
                                  sizesSelection: self.$sizesSelection,
                                  pricesSelection: self.$pricesSelection
                                )
            })
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingSortFilterPanel = true
                }, label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down.circle")
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                    .padding(15)
                })
            )
            
            WelcomeView()
        }
        .environmentObject(favorites)
//        .phoneOnlyStackNavigationView()
    }
    
    private func filteredCountries(resorts: [Resort]) -> [Resort] {
        return filter(resorts: resorts, selections: countriesSelection, valuePath: \.country)
    }
    
    private func filteredSizes(resorts: [Resort]) -> [Resort] {
        return filter(resorts: resorts, selections: sizesSelection, valuePath: \.sizeText)
    }
    
    private func filteredPrices(resorts: [Resort]) -> [Resort] {
        return filter(resorts: resorts, selections: pricesSelection, valuePath: \.priceText)
    }
    
    private func filter(resorts: [Resort], selections: [String], valuePath: KeyPath<Resort, String>) -> [Resort] {
        if selections.contains("All") {
            return resorts
        }
        
        var list = [Resort]()
        for resort in resorts {
            if selections.contains(resort[keyPath: valuePath]) {
                list.append(resort)
            }
        }
        return list
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
