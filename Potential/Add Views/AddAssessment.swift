//
//  AddAssessment.swift
//  Potential
//
//  Created by Elias Tabaka on 28/06/2023.
//

import SwiftUI

struct AddAssessment: View {
    let module: Module
    @ObservedObject var modules = ViewModules()
    
    var body: some View {
        List {
            Section {
                ForEach(modules.assessmentList) { assessment in
                    Text(assessment.name)
                }
            }
        }
    }
    
    init(module: Module) {
        self.module = module
        modules.getAssessmentData(moduleDocumentId: module.extId ?? "")
        
    }
}

//struct AddAssessment_Previews: PreviewProvider {
//    static var previews: some View {
//        AddAssessment()
//    }
//}
