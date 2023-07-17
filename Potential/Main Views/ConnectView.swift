//
//  ConnectView.swift
//  Potential
//
//  Created by Elias Tabaka on 17/07/2023.
//

import SwiftUI

struct ConnectView: View {
    @Binding private var username: String
    @Binding private var email: String
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ModuleView(username: $username, email: $email)
                } label: {
                    Text("Study Partners")
                }
                
                NavigationLink {
                    DepartmentTopicsView()
                } label: {
                    Text("University Topics")
                }
            }
        }
    }
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
    }
}
