//
//  AddAssessment.swift
//  Potential
//
//  Created by Elias Tabaka on 28/06/2023.
//

import SwiftUI

struct AddAssessment: View {
    let module: Module
    @ObservedObject var modulesExt = ViewModules()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    
    var body: some View {
        List {
            Section {
                Text(module.name ?? "NA")
            } header: {
                Text("Name")
            }
            
            Section {
                Text(String(module.credits))
            } header: {
                Text("Credits")
            }
            
            Section {
                ForEach(assessments) { assessment in
                    if assessment.moduleCode == module.code {
                        VStack(alignment: .leading) {
                            Text(assessment.moduleCode ?? "Unknown")
                            Text(assessment.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown")
                        }
                    }
                }
                .onDelete(perform: deleteAssessments)
            } header: {
                Text(noOfAssessmentsAdded() == 0 ? "" : "Assessments added")
            }
            
            Section {
                ForEach(modulesExt.assessmentList) { assessmentE in
                    HStack {
                        Text(assessmentE.name)
                        Spacer()
                        if !isAssessmentAdded(code: module.code ?? "NA", name: assessmentE.name) {
                            Button {
                                let newAssessment = Assessment(context: moc)
                                newAssessment.id = UUID()
                                newAssessment.name = assessmentE.name
                                newAssessment.percentage = Int16(assessmentE.percentage)
                                newAssessment.grade = 0
                                newAssessment.moduleCode = module.code
                                
                                
                                do {
                                    try moc.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            } label: {
                                Label("", systemImage: "plus")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
                
            } header: {
                Text("Available assessments to add")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(module.code ?? "NA")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(module: Module) {
        self.module = module
        modulesExt.getAssessmentData(moduleDocumentId: module.extId ?? "")
        
    }
    
    func isAssessmentAdded(code: String, name: String) -> Bool {
        for assessment in assessments {
            if assessment.moduleCode ?? "NA" == code && assessment.name ?? "NA" == name {
                return true
            }
        }
        return false
    }
    
    func noOfAssessmentsAdded() -> Int {
        var counter = 0
        
        for assessment in assessments {
            if assessment.moduleCode == module.code {
                counter += 1
            }
        }
        
        return counter
    }
    
    func deleteAssessments(at offsets: IndexSet) {
        for offset in offsets {
            let assessment = assessments[offset]
            moc.delete(assessment)
        }
        
        try? moc.save()
    }
}

//struct AddAssessment_Previews: PreviewProvider {
//    static var previews: some View {
//        AddAssessment()
//    }
//}
