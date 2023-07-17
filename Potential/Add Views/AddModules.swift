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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modulesExt.list) { moduleE in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(moduleE.code)
                            Text(moduleE.name)
                        }
                        Spacer()
                        
                        if !isModuleAdded(code: moduleE.code) {
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
                                dismiss()
                            } label: {
                                Label("", systemImage: "plus")
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
            .onAppear() {
                modulesExt.getData()
            }
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
