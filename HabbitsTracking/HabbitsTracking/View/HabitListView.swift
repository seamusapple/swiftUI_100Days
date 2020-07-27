//
//  HabbitListView.swift
//  HabbitsTracking
//
//  Created by Ramsey on 2020/6/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct HabitListView: View {
    
    @ObservedObject var habit = Habit()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(habit.activities) { activityItem in
                    NavigationLink(destination:
                        EditActivityView(habit: self.habit, activityId: activityItem.id)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(activityItem.name)
                                .font(.headline)
                            Text(activityItem.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                Text("Completed")
                                Text("\(activityItem.amount)")
                                    .foregroundColor(activityItem.getCorrespondingColor())
                                Text(activityItem.timeDesc())
                            }
                            .font(.body)
                        }
                    }
                }
                .onDelete(perform: self.deleteItem(at:))
            }
            
            .navigationBarTitle("Habits")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {
                            self.showingAddActivity.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    }
                )
            )
        }
        .sheet(isPresented: $showingAddActivity) {
            AddActivityView(habit: self.habit)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        self.habit.activities.remove(atOffsets: offsets)
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView().colorScheme(.dark)
    }
}
