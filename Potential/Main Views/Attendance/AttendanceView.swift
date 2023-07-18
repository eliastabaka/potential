//
//  AttendanceView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct AttendanceView: View {
    let weeks = [24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    @State private var showingAdd = false
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var attendanceEntries: FetchedResults<Attendance>
    
    var body: some View {
        if !networkMonitor.isConnected {
            NoConnectionView()
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
                                                .foregroundStyle(entry.attended ? .green : .red)
                                            
                                                .padding(1)
                                            Text(entry.date?.formatted() ?? "NA")
                                                .padding(1)
                                        }
                                        
                                    }
                                }
                            }
                            .onDelete(perform: deleteAttendance)
                            
                            
                        } header: {
                            if checkIfWeekExists(week: week) {
                                Text(week > 12 ? "Semester 2 Week \(week - 12)" : "Semester 1 Week \(week)")
                            }
                        }
                        
                        
                        
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Attendance")
                .navigationBarTitleDisplayMode(.inline)
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
