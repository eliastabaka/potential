//
//  MainView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            Text("Main View")
                .navigationTitle("Potential")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
