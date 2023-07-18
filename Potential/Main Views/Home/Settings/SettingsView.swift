//
//  SettingsView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.code)]) var modules: FetchedResults<Module>
    @Binding var name: String
    @Binding var email: String
    @Binding var startDateStorage: String
    @Binding var endDateStorage: String
    @State var startDate = Date.now
    @State var endDate = Date.now
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Name", text: $name)
                        Text(email)
                            .foregroundColor(.secondary)
                    } header: {
                        Text("Personal details")
                    }
                    
                    Section {
                        DatePicker(selection: $startDate, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        .onChange(of: startDate) {v in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            startDateStorage = dateFormatter.string(from: startDate)
                        }
                                  
                        DatePicker(selection: $endDate, in: (startDate + 86400)..., displayedComponents: .date) {
                            Text("End Date")
                        }
                        .onChange(of: endDate) {v in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            endDateStorage = dateFormatter.string(from: v)
                        }
                        
                    } header: {
                        Text("Semester Dates")
                    }
                    
                    NavigationLink {
                       AddModules()
                    } label: {
                        Text("Add modules")
                    }
                    
                    Section {
                        ForEach(modules) { module in
                            NavigationLink {
                                AddAssessment(module: module)
                            } label: {
                                Text(module.code ?? "Unknown code")
                            }
                            
                        }
                        .onDelete(perform: deleteModules)
                    } header: {
                        Text("Your modules")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                startDate = dateFormatter.date(from: startDateStorage) ?? (Date.now)
                endDate = dateFormatter.date(from: endDateStorage) ?? Date.now
            }
        }
    }
    
    func deleteModules(at offsets: IndexSet) {
        for offset in offsets {
            let module = modules[offset]
            moc.delete(module)
        }
        
        try? moc.save()
    }
}
