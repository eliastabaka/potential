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
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var attendanceEntries: FetchedResults<Attendance>
    
    var body: some View {
        if !networkMonitor.isConnected {
            Text("No internet")
        } else {
            NavigationView {
                List {
                    ForEach(weeks, id: \.self) { week in
                        
                        Section {
                            
                            ForEach(attendanceEntries) { entry in
                                if week == Int(entry.week) {
                                    NavigationLink {
                                        UpdateAttendance(attendance: entry)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(entry.title ?? "NA")
                                                .fontWeight(.medium)
                                                .foregroundColor(entry.attended ? .green : .red)
                                                .padding(1)
                                            Text(entry.date?.formatted() ?? "NA")
                                                .foregroundColor(.secondary)
                                                .padding(1)
                                        }
                                        
                                    }
                                }
                            }
                            .onDelete(perform: deleteAttendance)
                            
                            
                        } header: {
                            if checkIfWeekExists(week: week) {
                                Text("Week \(week)")
                            }
                        }
                        
                        
                        
                    }
                }
                .navigationTitle("Attendance")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
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
    }
    
    func deleteAttendance(at offsets: IndexSet) {
        for offset in offsets {
            let attendanceEntry = attendanceEntries[offset]
            moc.delete(attendanceEntry)
        }
        try? moc.save()
    }
    
    func checkIfWeekExists(week: Int) -> Bool {
        for attendance in attendanceEntries {
            if attendance.week == week {
                return true
            }
        }
        return false
    }
    
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
