//
//  ModuleView.swift
//  Potential
//
//  Created by Elias Tabaka on 14/06/2023.
//

import SwiftUI

struct ModuleView: View {
    @ObservedObject var modules = ViewModules()
    @Binding  var username: String
    @Binding private var email: String
    
    var body: some View {
        List {
            ForEach(modules.list) { module in
                NavigationLink {
                    ModuleStudentsView(username: $username, email: $email, module: module)
                } label: {
                    VStack(alignment: .leading) {
                        Text(module.code)
                        Text(module.name)
                    }
                }
            }
        }
        .onAppear() {
            modules.getData()
        }
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
        modules.getData()
    }
}
