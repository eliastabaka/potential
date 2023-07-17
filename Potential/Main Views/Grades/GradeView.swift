//
//  GradeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI


struct GradeView: View {
    @State private var showingAdd = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.code)]) var modules: FetchedResults<Module>
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @FetchRequest(sortDescriptors: [SortDescriptor(\.moduleCode), SortDescriptor(\.name)]) var assessments: FetchedResults<Assessment>
    
    @State private var gradeAverage = 0.0
    @State private var showingPredictions = false
    
    var number = 0
    
    var body: some View {
        if !networkMonitor.isConnected {
            Text("No internet")
        } else {
            NavigationView {
                List {
//                    if !assessments.isEmpty {
//                        Section {
//                            HStack {
//                                Spacer()
//                                Text("Average: \(String(format: "%.2f", gradeAverage))")
//                                    .font(.title2)
//                                    .fontWeight(.medium)
//                                Spacer()
//                            }
//                        }
//                    }
                    
                    ForEach(modules) { module in
                        Section {
                            ForEach(assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) { assessment in
                                NavigationLink {
                                    AddGrade(assessment: assessment)
                                } label: {
                                    
                                    
                                    HStack {
                                        Text("\(assessment.name ?? "n") ( \(Int(assessment.percentage))%)")
                                        Spacer()
                                        
                                        Text(assessment.grade == 0 ? "0" : "\(assessment.grade)")
                                            .foregroundColor(assessment.grade == 0 ? .red : .primary)
                                    }
                                    .padding(3)
                                    
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
                .navigationTitle("Grades Average:    \(String(format: "%.2f", gradeAverage))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingPredictions = true
                        } label: {
                            Label("Predict", systemImage: "lightbulb")
                        }
                    }
                }
                .sheet(isPresented: $showingPredictions) {
                    GradePredictionView()
                }
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

