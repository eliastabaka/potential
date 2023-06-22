//
//  MainView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct MainView: View {
    @State private var showingSettings = false
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        NavigationView {
            Text("Main View")
                .navigationTitle("Potential")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingSettings = true
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(name: $name, email: $email)
                }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
