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
    @State private var date = Date.now
    @State private var semester = 1
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $title)
            }
            
            Section {
                DatePicker(selection: $date) {
                    Text("Select a date")
                }
                Picker("Select Week", selection: $week) {
                    ForEach(weeksArray, id: \.self) { week in
                        Text("\(week)").tag(week)
                    }
                }
                Picker("", selection: $semester) {
                    ForEach([1, 2], id: \.self) { id in
                        Text("Semester \(id)")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Toggle("Attended?", isOn: $isAttended)
            }
            
            Section {
                Button("Save") {
                    attendance.title = title
                    attendance.week = Int16(week + ((semester - 1) * 12))
                    attendance.attended = isAttended
                    attendance.date = date
                    
                    try? moc.save()
                    dismiss()
                    
                }
            }
        }
        .onAppear() {
            title = attendance.title ?? "NA"
            
            if attendance.week > 12 {
                week = Int(attendance.week - 12)
                semester = 2
            } else {
                week = Int(attendance.week)
                semester = 1
            }
            
            isAttended = attendance.attended
            date = attendance.date ?? Date.now
        }
    }
}
