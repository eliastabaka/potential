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
    
    @State private var duration = 0.0
    @State private var moduleSelection: Module?
    @State private var title = ""
    @State private var week = 1
    @State private var isAttended = false
    
    
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Title", text: $title)
                    Picker("Select module", selection: $moduleSelection) {
                        ForEach(modules) { module in
                            Text(module.code!)
                                .tag(Optional(module))
                        }
                    }
                    Picker("Select Week", selection: $week) {
                        ForEach(weeksArray, id: \.self) { week in
                            Text("\(week)").tag(week)
                        }
                    }
                    Toggle("Attended?", isOn: $isAttended)
                    
                    if isAttended {
                        VStack {
                            Stepper("Select duration", value: $duration, in: 0...8, step: 0.25)
                            Text("\(duration) hours")
                        }
                    }
                }
                
                Section {
                    Button("Save") {
                        let newAttendanceEntry = Attendance(context: moc)
                        newAttendanceEntry.id = UUID()
                        newAttendanceEntry.title = title
                        newAttendanceEntry.duration = duration
                        newAttendanceEntry.moduleCode = moduleSelection?.code ?? "N/A"
                        newAttendanceEntry.week = Int16(week)
                        newAttendanceEntry.attended = isAttended
                        
                        try? moc.save()
                        dismiss()
                        
                    }
                }
            }
                .navigationTitle("Add new entry")
        }
    }
}

struct AddAttendance_Previews: PreviewProvider {
    static var previews: some View {
        AddAttendance()
    }
}
