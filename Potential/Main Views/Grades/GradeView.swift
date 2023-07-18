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
    @State private var showingCreditsWarning = false
    @State private var showingAssessmentWarning = false
    
    var number = 0
    
    var body: some View {
        if !networkMonitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                List {
                    
                    Section {
                        HStack() {
                            Spacer()
                            Text("Grades Average and Prediction are for information only and might differ from the year final grade you are awarded.")
                                .foregroundStyle(.blue)
                                .font(.footnote)
                            Spacer()
                        }
                    }
                    
                    if showingCreditsWarning {
                        Section {
                            Text("Credits Sum: \(creditsSum())/120")
                        } header: {
                            if creditsSum() > 120 {
                                Text("Warning: Delete some modules")
                                    .foregroundStyle(.red)
                            } else {
                                Text("Warning: Add more modules")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                        
                        if showingAssessmentWarning {
                            Section {
                                ForEach(checkModules()) { module in
                                    Text(module.code ?? "NA")
                                        .foregroundStyle(.red)
                                }
                            } header: {
                                Text("Warning: Missing assessments in")
                                    .foregroundStyle(.red)
                            }
                        }
                        
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
                                                .foregroundStyle(assessment.grade == 0 ? .yellow : .primary)
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
                            showingCreditsWarning = creditsSum() == 120 ? false : true
                            showingAssessmentWarning = checkModules().isEmpty ? false : true
                        }
                        .navigationTitle("Grades Average:  \(String(format: "%.2f", gradeAverage))")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showingPredictions = true
                                } label: {
                                    Label("Predict", systemImage: "compass.drawing")
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
        
        func creditsSum() -> Int {
            var counter = 0
            
            for m in modules {
                counter += Int(m.credits)
            }
            
            return counter
        }
        
        func checkModules() -> [Module] {
            var invalidModules = [Module]()
            
            for module in modules {
                var counter = 0
                for assessment in assessments.filter({ a in return module.code ?? "" == a.moduleCode ?? ""}) {
                    counter += Int(assessment.percentage)
                }
                if counter != 100 {
                    invalidModules.append(module)
                }
            }
            
            return invalidModules
        }
    }
    
    struct GradeView_Previews: PreviewProvider {
        static var previews: some View {
            GradeView()
        }
    }
    
