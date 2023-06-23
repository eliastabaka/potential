//
//  GradeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct GradeView: View {
    @State private var showingAdd = false
    
    var body: some View {
        NavigationView {
            Text("Grade View")
                .navigationTitle("Grades")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAdd = true
                        } label: {
                            Label("Add Grade", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddGrade()
                }
        }
        
    }
}

struct GradeView_Previews: PreviewProvider {
    static var previews: some View {
        GradeView()
    }
}

