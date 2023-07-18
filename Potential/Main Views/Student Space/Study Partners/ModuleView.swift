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
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(searchResults) { module in
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
        .searchable(text: $searchText, prompt: "Look for a module")
        .onAppear() {
            modules.getData()
        }
        .navigationTitle("Study Partners")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
        modules.getData()
    }
    
    var searchResults: [ModuleExt] {
            if searchText.isEmpty {
                return modules.list
            } else {
                return modules.list.filter { $0.code.contains(searchText.uppercased()) || $0.name.lowercased().contains(searchText)}
            }
        }
}
