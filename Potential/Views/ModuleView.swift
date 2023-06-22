//
//  ModuleView.swift
//  Potential
//
//  Created by Elias Tabaka on 14/06/2023.
//

import SwiftUI

struct ModuleView: View {
    @ObservedObject var modules = ViewModules()
    @Binding private var username: String
    @Binding private var email: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modules.list) { module in
                    NavigationLink {
                        ModuleStudentsView(username: $username, email: $email, module: module)
                    } label: {
                        Text(module.name)
                    }
                }
            }
            .navigationTitle("Modules")
        }
    }
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
        modules.getData()
    }
}

//struct ModuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModuleView(username: "Name Name", email: "email")
//    }
//}
