//
//  AddModules.swift
//  Potential
//
//  Created by Elias Tabaka on 01/07/2023.
//

import SwiftUI

struct AddModules: View {
    @ObservedObject var modulesExt = ViewModules()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.code)]) var modules: FetchedResults<Module>
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
            List {
                ForEach(searchResults) { moduleE in
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(moduleE.code)
                                Text(moduleE.name)
                            }
                            Spacer()
                            
                            if !isModuleAdded(code: moduleE.code) {
                                Label("", systemImage: "plus")
                                    .onTapGesture() {
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
                                        dismiss()
                                    }
                            }
                        }
                    }
                }
                
            }
            .onAppear() {
                modulesExt.getData()
            }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Look for a module")
    }
    
    var searchResults: [ModuleExt] {
            if searchText.isEmpty {
                return modulesExt.list
            } else {
                return modulesExt.list.filter { $0.code.contains(searchText.uppercased()) || $0.name.lowercased().contains(searchText)}
            }
        }

    
    func isModuleAdded(code: String) -> Bool {
        for module in modules {
            if module.code ?? "NA" == code {
                return true
            }
        }
        return false
    }
}

struct AddModules_Previews: PreviewProvider {
    static var previews: some View {
        AddModules()
    }
}
