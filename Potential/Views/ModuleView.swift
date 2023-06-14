//
//  ModuleView.swift
//  Potential
//
//  Created by Elias Tabaka on 14/06/2023.
//

import SwiftUI

struct ModuleView: View {
    @ObservedObject var modules = ViewModules()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modules.list) { module in
                    NavigationLink {
                        GroupStudentsView(module: module)
                    } label: {
                        Text(module.name)
                    }
                }
            }
            .navigationTitle("Modules")
        }
    }
    
    init() {
        modules.getData()
    }
}

struct ModuleView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleView()
    }
}
