//
//  DeadlineView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct DeadlineView: View {
    @State private var showingAdd = false
    
    var body: some View {
        NavigationView {
            Text("Deadline View")
                .navigationTitle("Deadlines")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAdd = true
                        } label: {
                            Label("Add Deadline", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddDeadline()
                }
        }
        
    }
}

struct DeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineView()
    }
}
