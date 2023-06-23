//
//  AddAttendance.swift
//  Potential
//
//  Created by Elias Tabaka on 23/06/2023.
//

import SwiftUI

struct AddAttendance: View {
    var body: some View {
        NavigationView {
            Text("Add Attendance")
                .navigationTitle("Add new entry")
        }
    }
}

struct AddAttendance_Previews: PreviewProvider {
    static var previews: some View {
        AddAttendance()
    }
}
