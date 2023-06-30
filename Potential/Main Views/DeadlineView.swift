//
//  DeadlineView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct DeadlineView: View {
    @State private var showingAdd = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var deadlines: FetchedResults<Deadline>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(deadlines) { deadline in
                    Section {
                        VStack(alignment: .leading) {
                            Text(deadline.name ?? "")
                            Text(deadline.date?.formatted() ?? "NA")
                            Text(Calendar.current.dateComponents([.day], from: Date.now, to: deadline.date ?? Date.now).day?.formatted() ?? "a")
                            Text("Time worked on: \(String(format: "%.2f", deadline.duration))h")
                        }
                    }
                }
                .onDelete(perform: deleteDeadline)
            }
            .navigationTitle("Deadlines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Label("Add Deadline", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddDeadline()
            }
        }
        
    }
    func deleteDeadline(at offsets: IndexSet) {
        for offset in offsets {
            let deadline = deadlines[offset]
            moc.delete(deadline)
        }
        
        try? moc.save()
    }
}

struct DeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineView()
    }
}
