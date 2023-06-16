//
//  ContentView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI


struct ContentView: View {
    @AppStorage("username") var username = "Hannah Cole"
    @AppStorage("email") var email = "hcole1@sheffield.ac.uk"
    
    
    var body: some View {
        ModuleView(username: username, email: email)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
