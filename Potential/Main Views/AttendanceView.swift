//
//  AttendanceView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct AttendanceView: View {
    @State private var showingAdd = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var attendanceEntries: FetchedResults<Attendance>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(attendanceEntries) {
                    Text(String($0.duration))
                }
                .onDelete(perform: deleteAttendance)
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
