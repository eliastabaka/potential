//
//  AddDeadline.swift
//  Potential
//
//  Created by Elias Tabaka on 23/06/2023.
//

import SwiftUI

struct AddDeadline: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var duration = 0.0
    @State private var name = ""
    @State private var date = Date.now
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    TextField("Title", text: $name)
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
                        let deadline = Deadline(context: moc)
                        deadline.id = UUID()
                        deadline.name = name
                        deadline.date = date
                        deadline.duration = duration
                        
                        try? moc.save()
                        dismiss()
                    }
                }
                
            }
        }
    }
}

struct AddDeadline_Previews: PreviewProvider {
    static var previews: some View {
        AddDeadline()
    }
}
