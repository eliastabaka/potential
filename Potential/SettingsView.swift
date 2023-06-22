//
//  SettingsView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        NavigationView {
            List {
                TextField("Name", text: $name)
                TextField("Email Address", text: $email)
            }
                .navigationTitle("Settings")
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
