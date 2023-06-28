//
//  AddGrade.swift
//  Potential
//
//  Created by Elias Tabaka on 23/06/2023.
//

import SwiftUI

struct AddGrade: View {
    let assessment: Assessment
    @State private var selectedNumber = 0
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose your grade", selection: $selectedNumber) {
                    ForEach(0..<101) {
                        Text("\($0)")
                    }
                }
                Button("Save") {
                    assessment.grade = Int16(selectedNumber)
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
            }
                .navigationTitle("Add grade entry")
        }
    }
}

//struct AddGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        AddGrade()
//    }
//}
