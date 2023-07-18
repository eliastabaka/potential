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
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        if !networkMonitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                List {
                    Section {
                        NavigationLink {
                            ModuleView(username: $username, email: $email)
                        } label: {
                            Text("Study Partners")
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            DepartmentTopicsView(author: $email)
                        } label: {
                            Text("University Topics")
                        }
                    }
                }
                .navigationTitle("Student Space")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    init(username: Binding<String>, email: Binding<String>) {
        self._username = username
        self._email = email
    }
}
