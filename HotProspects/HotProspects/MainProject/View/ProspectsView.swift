//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Ramsey on 2020/7/10.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

enum SortType {
    case name, date
}

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var sort: SortType = .name
    @State private var isShowingSort = false
    
    let random = ["Brittany Brown\nbrittany.brown@random.com", "Adina Woodward\nadina.woodward@random.com", "Euan Rankin\neuan.rankin@random.com", "Arman Lawrence\narman.lawrence@random.com", "Rumaysa Lang\nrumaysa.lang@random.com", "Pawel Kerr\npawel.kerr@random.com", "Ashlee Reilly\nashlee.reilly@random.com", "Tabitha Monroe\ntabitha.monroe@random.com", "Deen Key\ndeen.key@random.com", "Aasiyah Byrd\naasiyah.byrd@random.com", "Esmee Robinson\n@random.com", "Bill Archer\nbill.archer@random.com", "Umar Whitworth\numar.whitworth@random.com", "Azra Hernandez\nazra.hernandez@random.com", "Nadine Matthams\nnadine.matthams@random.com", "Mateo Pearce\nmateo.pearce@random.com", "Shelbie Santiago\nshelbie.santiago@random.com", "Md Stokes\n@md.stokesrandom.com", "Mathilde Macfarlane\nmathilde.macfarlane@random.com", "Jamila Fernandez\njamila.fernandez@random.com"]
    
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var filteredSortedProspects: [Prospect] {
        switch sort {
        case .name:
            return filteredProspects.sorted { $0.name < $1.name }
        case .date:
            return filteredProspects.sorted { $0.date > $1.date }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredSortedProspects) { prospect in
                    HStack {
                        if self.filter == .none {
                            if !prospect.isContacted {
                                Image(systemName: "envelope.badge.fill")
                            } else {
                                Image(systemName: "envelope.fill")
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.isShowingSort = true
                    }) {
                        Image(systemName: "chevron.up.chevron.down")
                        Text("Sort")
                    }
                ,trailing:
                    Button(action: {
                        self.isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }
            )
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: self.random.randomElement()!, completion: self.handleScan)
            }
            .actionSheet(isPresented: $isShowingSort) {
                ActionSheet(title: Text("Sort by"), buttons: [
                    .default(Text((self.sort == .name ? "✓ " : "") + "Name"), action: { self.sort = .name }),
                    .default(Text((self.sort == .date ? "✓ " : "") + "Most recent"), action: { self.sort = .date }),
                ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
       switch result {
       case .success(let code):
           let details = code.components(separatedBy: "\n")
           guard details.count == 2 else { return }

           let person = Prospect()
           person.name = details[0]
           person.emailAddress = details[1]

           self.prospects.add(person)
       case .failure(let error):
            print("Scanning failed with reason: \(error.localizedDescription)")
       }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
