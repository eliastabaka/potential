//
//  GradePredictionView.swift
//  Potential
//
//  Created by Elias Tabaka on 29/06/2023.
//

import SwiftUI

// Struct wrapping around assessment and module + adding extra prediction field
struct PredictionAssessment: Identifiable, Equatable {
    var id = UUID()
    let assessment: Assessment
    let module: Module
    var gradeEstimation: Double
}


// Helper View containing individual state for each assessment
struct PAView : View {
    @Binding var predictionAssessment: PredictionAssessment
    @State var selection = 0.0
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(predictionAssessment.assessment.name ?? "n") ( \(Int(predictionAssessment.assessment.percentage))%)")
                    Spacer()
                    Text(String(Int(predictionAssessment.gradeEstimation)))
                }
                Slider(value: $selection, in: 0...100)
            
            }
            .onChange(of: selection) { value in
                predictionAssessment.gradeEstimation = selection
            }
        } header: {
            Text("\(predictionAssessment.module.code ?? "N/A") \(predictionAssessment.module.name ?? "N/A")")
        }
    }
}


// Main View
struct GradePredictionView: View {
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    
    @State private var completedGradesAverage = 0.0
    @State private var pAssessments = [PredictionAssessment]()
    @State private var predictionsSum = 0.0
    
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach($pAssessments) { a in
                    PAView(predictionAssessment: a, selection: 0.0)
                        .onChange(of: pAssessments) { v in
                            addNewPredictions()
                        }
                }
                
            }
            .onAppear() {
                // Populating pAssessments array with predictionAssessments
                for module in modules {
                    for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? "" && a.grade == 0}) {
                        pAssessments.append(PredictionAssessment(assessment: assessment, module: module, gradeEstimation: 0.0))
                    }
                }
                updateCompletedAverage()
            }
            .navigationTitle("Prediction:  \(String(format: "%.2f", (predictionsSum + completedGradesAverage) / 120.0))")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addNewPredictions() {
        predictionsSum = 0
        for pAssessment in pAssessments {
            predictionsSum += pAssessment.gradeEstimation * Double(pAssessment.assessment.percentage) / 100.0 * Double(pAssessment.module.credits)
        }
    }
    
    func updateCompletedAverage() {
        var sum = 0.0
        for module in modules {
            for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) {
                sum += Double(assessment.grade) * Double(assessment.percentage) / 100.0 * Double(module.credits)
            }
        }
        
        completedGradesAverage = sum
    }
}


struct GradePredictionView_Previews: PreviewProvider {
    static var previews: some View {
        GradePredictionView()
    }
}
