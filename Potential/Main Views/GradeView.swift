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
    
    @State private var gradeAverage = 0.0
    @State private var showingPredictions = false
    
    var number = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Average \(String(format: "%.2f", gradeAverage))")
                }
                
                ForEach(modules) { module in
                    Section {
                        ForEach(assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) { assessment in
                            NavigationLink {
                                AddGrade(assessment: assessment)
                            } label: {
                                VStack(alignment: .leading) {

                                    Text(assessment.name ?? "n")
                                    Text(String(Int(assessment.percentage)))
                                    Text(String(assessment.grade))

                                }
                            }
                        }
                    } header: {
                        Text("\(module.code ?? "N/A") \(module.name ?? "N/A")")
                    } footer: {
                        Text("\(module.credits) credits")
                    }
                }
            }
            .onAppear() {
                updateAverage()
            }
            .navigationTitle("Grades")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingPredictions = true
                    } label: {
                        Text("Predict")
                    }
                }
            }
            .sheet(isPresented: $showingPredictions) {
                GradePredictionView()
            }
        }
    }
    
    func updateAverage() {
        var sum = 0.0
        for module in modules {
            for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) {
                sum += Double(assessment.grade) * Double(assessment.percentage) / 100.0 * Double(module.credits)
            }
        }
        
        gradeAverage = sum / 120.0
    }
}

struct GradeView_Previews: PreviewProvider {
    static var previews: some View {
        GradeView()
    }
}

