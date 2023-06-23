//
//  AttendanceView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct AttendanceView: View {
    @State private var showingAdd = false
    
    var body: some View {
        NavigationView {
            Text("Attendance View")
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
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
