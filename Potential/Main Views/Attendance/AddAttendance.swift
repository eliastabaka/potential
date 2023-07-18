//
//  AddAttendance.swift
//  Potential
//
//  Created by Elias Tabaka on 23/06/2023.
//

import SwiftUI

struct AddAttendance: View {
    let weeksArray = [1,2,3,4,5,6,7,8,9,10,11,12]
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var week = 1
    @State private var semester = 1
    @State private var isAttended = false
    @State private var date = Date.now
    
    
    
    
    var body: some View {
        NavigationView {
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
                        let newAttendanceEntry = Attendance(context: moc)
                        newAttendanceEntry.id = UUID()
                        newAttendanceEntry.title = title
                        newAttendanceEntry.week = Int16(week + ((semester - 1) * 12))
                        newAttendanceEntry.attended = isAttended
                        newAttendanceEntry.date = date
                        
                        try? moc.save()
                        dismiss()
                        
                    }
                }
            }
        }
    }
}

struct AddAttendance_Previews: PreviewProvider {
    static var previews: some View {
        AddAttendance()
    }
}
