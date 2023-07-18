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
                        HStack() {
                            Spacer()
                            Text("Your data from Study Partners and University Topics is stored on remote servers and available to all app users. You can withdraw it at any time by contacting you institution's administration.")
                                .foregroundStyle(.blue)
                                .font(.footnote)
                            Spacer()
                        }
                    }
                    
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
