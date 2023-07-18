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
                ForEach(modulesExt.assessmentList) { assessmentE in
                    HStack {
                        Text(assessmentE.name)
                        Spacer()
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
                    }
                }
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
            }
        }
    }
    
    init(module: Module) {
        self.module = module
        modulesExt.getAssessmentData(moduleDocumentId: module.extId ?? "")
        
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
