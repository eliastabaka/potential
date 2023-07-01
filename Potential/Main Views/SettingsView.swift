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
                    
                    NavigationLink {
                       AddModules()
                    } label: {
                        Text("Add modules")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
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
