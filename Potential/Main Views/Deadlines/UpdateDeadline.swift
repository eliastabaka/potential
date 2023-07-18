//
//  UpdateDeadline.swift
//  Potential
//
//  Created by Elias Tabaka on 30/06/2023.
//

import SwiftUI

struct UpdateDeadline: View {
    let deadline: Deadline
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var duration = 0.0
    @State private var name = ""
    @State private var date = Date.now
    
    
    var body: some View {
            List {
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    DatePicker(selection: $date, in: Date.now...) {
                        Text("Select a date")
                    }
                    Stepper("How much time you already worked on it", value: $duration, in: 0...100, step: 1)
                    Text("\(Int(duration))h")
                }
                
                Section {
                    Button("Save") {
                        deadline.name = name
                        deadline.date = date
                        deadline.duration = duration
                        
                        try? moc.save()
                        dismiss()
                    }
                }
                
            }
            .onAppear() {
                duration = deadline.duration
                name = deadline.name ?? "NA"
                date = deadline.date ?? Date.now
            }
    }
}
