//
//  Habit.swift
//  HabbitsTracking
//
//  Created by Ramsey on 2020/6/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ActivityItem: Identifiable, Codable {
    let id = UUID()
    var name: String {
        didSet { date = Date() }
    }
    var description: String {
        didSet { date = Date() }
    }
    var amount: Int = 0 {
        didSet {
            date = Date()
            if amount < 0 { amount = 0 }
        }
    }
    
    var date = Date()
    
    func timeDesc() -> String {
        return (amount == 0 || amount == 1) ? "time" : "times"
    }
    
    func getCorrespondingColor() -> Color {
        if amount == 0 {
            return Color.red
        }
        return  Color.green
    }
}

class Habit: ObservableObject {
    @Published var activities = [ActivityItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "Activities") else { self.activities = []; return }
        guard let activities = try? decoder.decode([ActivityItem].self, from: data) else { self.activities = []; return }
        self.activities = activities
    }
    
    func add(activity: ActivityItem) {
        activities.append(activity)
        sortActivities()
    }
    
    func update(activity: ActivityItem) {
        guard let index = getIndex(activity: activity) else { return }

        activities[index] = activity
        sortActivities()
    }
    
    func getActivity(id: UUID) -> ActivityItem {
        guard let index = getIndex(id: id) else { return ActivityItem(name: "", description: "", amount: 0) }

        return activities[index]
    }

    private func getIndex(activity: ActivityItem) -> Int? {
        return activities.firstIndex(where: { $0.id == activity.id })
    }

    private func getIndex(id: UUID) -> Int? {
        return activities.firstIndex(where: { $0.id == id })
    }
    
    private func sortActivities() {
        activities = activities.sorted { $0.date > $1.date }
    }
}
