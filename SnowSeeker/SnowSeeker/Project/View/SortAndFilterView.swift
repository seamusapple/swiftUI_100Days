//
//  SortAndFilterView.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

enum SortType {
    case `default`
    case name
    case country
}

enum FilterType {
    case country(items: [String])
    case size(items: [String])
    case price(items: [String])
}

struct SortAndFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var resorts: [Resort]
    
    @Binding var sortType: SortType
    @Binding var countriesSelection: [String]
    @Binding var sizesSelection: [String]
    @Binding var pricesSelection: [String]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort resorts")) {
                    Picker("Sort resorts", selection: self.$sortType) {
                        Text("Default").tag(SortType.default)
                        Text("Name").tag(SortType.name)
                        Text("Country").tag(SortType.country)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Filter resorts")) {
                    MultipleChoiceView(title: "Countries",
                                       values: countries,
                                       selections: $countriesSelection,
                                       convertValue: { $0 },
                                       updateSelection: { self.updateCountries(selection: $0) }
                    )
                    
                    MultipleChoiceView(title: "Sizes",
                                       values: sizes,
                                       selections: $sizesSelection,
                                       convertValue: { Resort.sizeText(from: $0) },
                                       updateSelection: { self.updateSizes(selection:$0) }
                    )
                    
                    MultipleChoiceView(title: "Prices",
                                       values: prices,
                                       selections: $pricesSelection,
                                       convertValue: { Resort.priceText(from: $0) },
                                       updateSelection: { self.updatePrices(selection: $0) }
                    )
                }
            }
            .navigationBarTitle("Sort and filter", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .padding(15)
                    })
            )
        }
    }
    
    func updateCountries(selection country: String) {
        update(selections: &countriesSelection, selection: country)
    }
    
    func updateSizes(selection size: String) {
        update(selections: &sizesSelection, selection: size)
    }

    func updatePrices(selection price: String) {
        update(selections: &pricesSelection, selection: price)
    }
    
    func update(selections: inout [String], selection: String) {
        if selection == "All" {
            selections = ["All"]
            return
        }
        
        if selections.contains(selection) {
            if let allIndex = selections.firstIndex(of: selection) {
                selections.remove(at: allIndex)
            }
            if selections.isEmpty {
                selections = ["All"]
            }
        } else {
            selections.append(selection)
            if let allIndex = selections.firstIndex(of: "All") {
                selections.remove(at: allIndex)
            }
        }
    }
}

extension SortAndFilterView {
    fileprivate var countries: [String] {
        return Array(Set(resorts.map { $0.country })).sorted()
    }
    
    fileprivate var sizes: [Int] {
        return Array(Set(resorts.map { $0.size })).sorted()
    }
    
    fileprivate var prices: [Int] {
        return Array(Set(resorts.map { $0.price })).sorted()
    }
}

struct MultipleChoiceView<ValueType: Hashable>: View {
    var title: String
    var values: [ValueType]
    @Binding var selections: [String]
    
    var convertValue: (_ value: ValueType) -> String
    var updateSelection: (_ selection: String) -> ()
    
    var body: some View {
        Group {
            Text(title)
                .font(.headline)
            
            HStack {
                Text("All")
                    .font(.subheadline)
                    .padding(.leading, 16)
                Spacer()
                if selections.contains("All") {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.updateSelection("All")
            }
            
            ForEach(values, id: \.self) { value in
                HStack {
                    Text(self.convertValue(value))
                        .font(.subheadline)
                        .padding(.leading, 16)
                    Spacer()
                    if self.selections.contains(self.convertValue(value)) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.updateSelection(self.convertValue(value))
                }
            }
        }
    }
}
struct SortAndFilterView_Previews: PreviewProvider {
    static let resorts: [Resort] = [
        Resort(id: "1", name: "", country: "USA", description: "", imageCredit: "", price: 3, size: 3, snowDepth: 0, elevation: 0, runs: 0, facilities: []),
        Resort(id: "2", name: "", country: "UK", description: "", imageCredit: "", price: 2, size: 1, snowDepth: 0, elevation: 0, runs: 0, facilities: []),
        Resort(id: "3", name: "", country: "France", description: "", imageCredit: "", price: 4, size: 2, snowDepth: 0, elevation: 0, runs: 0, facilities: [])
    ]
    
    static var previews: some View {
        SortAndFilterView(resorts: resorts,
                          sortType: Binding.constant(.default),
                          countriesSelection: .constant(["All"]),
                          sizesSelection: .constant(["All"]),
                          pricesSelection: .constant(["All"]))
    }
}
