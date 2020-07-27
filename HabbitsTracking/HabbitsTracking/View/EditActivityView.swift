//
//  EditActivityView.swift
//  HabbitsTracking
//
//  Created by Ramsey on 2020/6/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct EditActivityView: View {
    
    @ObservedObject var habit: Habit
    
    var activityId: UUID
    
    var activityItem: ActivityItem {
        return habit.getActivity(id: activityId)
    }
    var body: some View {
        Form {
            Text(self.activityItem.name)
            Text(self.activityItem.description)
            Stepper(
                onIncrement: { self.updateActivity(by: 1) },
                onDecrement: { self.updateActivity(by: -1) },
                label: { Text("Complete \(activityItem.amount) \(activityItem.timeDesc())") }
            )
        }
        .navigationBarTitle("Edit Activity")
    }
    
    func updateActivity(by change: Int) {
        var activity = self.activityItem
        activity.amount += change
        self.habit.update(activity: activity)
    }
}

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityView(habit: Habit(), activityId: UUID()).colorScheme(.dark)
    }
}
