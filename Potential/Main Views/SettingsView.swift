//
//  SettingsView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var modulesExt = ViewModules()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    TextField("Name", text: $name)
                    TextField("Email Address", text: $email)
                    
                    
                    Section {
                        ForEach(modulesExt.list) { moduleE in
                            HStack {
                                Text(moduleE.name)
                                Spacer()
                                Button {
                                    let newModule = Module(context: moc)
                                    newModule.id = UUID()
                                    newModule.code = moduleE.code
                                    newModule.name = moduleE.name
                                    newModule.extId = moduleE.id
                                    newModule.credits = Int16(moduleE.credits)
                                    
                                    do {
                                        try moc.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                } label: {
                                    Label("", systemImage: "plus")
                                }
                            }
                        }
                        
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
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear() {
                modulesExt.getData()
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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
