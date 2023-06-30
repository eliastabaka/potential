//
//  AttendanceView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct AttendanceView: View {
    let weeks = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    @State private var showingAdd = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var attendanceEntries: FetchedResults<Attendance>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(weeks, id: \.self) { week in
                    ForEach(attendanceEntries) { entry in
                        if week == Int(entry.week) {
                            Section {
                                VStack(alignment: .leading) {
                                    Text(String(entry.duration))
                                    Text(entry.title ?? "NA")
                                    Text(entry.moduleCode ?? "NA")
                                    Text(String(entry.week))
                                }
                                .foregroundColor(entry.attended ? .green : .red)
                            } header: {
                                Text("Week \(entry.week)")
                            }
                        }
                    }
                    .onDelete(perform: deleteAttendance)
                }
            }
            .navigationTitle("Attendance")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Label("Add Attendance", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddAttendance()
            }
        }
    }
    func deleteAttendance(at offsets: IndexSet) {
        for offset in offsets {
            let attendanceEntry = attendanceEntries[offset]
            moc.delete(attendanceEntry)
        }
        
        try? moc.save()
    }

}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
