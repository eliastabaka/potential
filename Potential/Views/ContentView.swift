//
//  ContentView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI


struct ContentView: View {
    @State private var myName = "Elias"
    @State private var myEmail = "mmtabaka1@sheffield.ac.uk"
    
    
    var body: some View {
        ModuleView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
