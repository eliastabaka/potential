//
//  GradePredictionView.swift
//  Potential
//
//  Created by Elias Tabaka on 29/06/2023.
//

import SwiftUI

struct EA: Identifiable, Equatable {
    var id = UUID()
    let assessment: Assessment
    let module: Module
    var pred: Double
}

struct EAView : View {
    
    @Binding var ea: EA
    @State var selection = 0.0
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text(ea.assessment.name ?? "n")
                Text(String(Int(ea.assessment.percentage)))
                Text(String(ea.pred))
                Slider(value: $selection, in: 0...100)
                
            }
            .onChange(of: selection) { value in
                ea.pred = selection
            }
            
        }
    }
}

struct GradePredictionView: View {
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    
    @State private var gradeAverage = 0.0
    @State var selection = 0.0
    @State private var EAs = [EA]()
    @State private var sum = 0.0
    
    var number = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Average \(String(format: "%.2f", gradeAverage))")
                }
                
                Section {
                    Text("Sum \(String(format: "%.2f", sum))")
                }
                
                Section {
                    Text("Prediction \(String(format: "%.2f", (sum + gradeAverage) / 120.0))")
                }
                
                ForEach($EAs) { a in
                    EAView(ea: a, selection: 0.0)
                        .onChange(of: EAs) { v in
                            add()
                        }
                }
                
            }
            .onAppear() {
                for module in modules {
                    for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? "" && a.grade == 0}) {
                        
                        EAs.append(EA(assessment: assessment, module: module, pred: 0.0))
                        
                    }
                }
                updateAverage()
            }
        }
    }
    
    func add() {
        sum = 0
        for i in EAs {
            sum += i.pred * Double(i.assessment.percentage) / 100.0 * Double(i.module.credits)
        }
    }
    
    func updateAverage() {
        var sum = 0.0
        for module in modules {
            for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) {
                sum += Double(assessment.grade) * Double(assessment.percentage) / 100.0 * Double(module.credits)
            }
        }
        
        gradeAverage = sum
    }
}


struct GradePredictionView_Previews: PreviewProvider {
    static var previews: some View {
        GradePredictionView()
    }
}
