//
//  UpdateAttendance.swift
//  Potential
//
//  Created by Elias Tabaka on 30/06/2023.
//

import SwiftUI

struct UpdateAttendance: View {
    let attendance: Attendance
    let weeksArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var week = 1
    @State private var isAttended = false
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
                Picker("Select Week", selection: $week) {
                    ForEach(weeksArray, id: \.self) { week in
                        Text("\(week)").tag(week)
                    }
                }
                Toggle("Attended?", isOn: $isAttended)
                
            }
            Section {
                Button("Save") {
                    attendance.title = title
                    attendance.week = Int16(week)
                    attendance.attended = isAttended
                    
                    try? moc.save()
                    dismiss()
                    
                }
            }
        }
        .onAppear() {
            title = attendance.title ?? "NA"
            week = Int(attendance.week)
            isAttended = attendance.attended
        }
        .navigationTitle("\(attendance.title ?? "NA")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
