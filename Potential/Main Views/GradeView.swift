//
//  GradeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct GradeView: View {
    @State private var showingAdd = false
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    var number = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modules) { module in
                    Section {
                        ForEach(assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) { assessment in
                            VStack(alignment: .leading) {
                                
                                Text(assessment.name ?? "n")
                                Text(String(Int(assessment.percentage)))
                                Text(String(assessment.grade))
                                
                            }
                        }
                    } header: {
                        Text("\(module.code ?? "N/A")(\(module.credits))")
                    }
                }
            }
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

