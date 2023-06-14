//
//  GroupNamesView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI

struct GroupStudentsView: View {
    let module: Module
    @ObservedObject var students = ViewStudent()
    
    
    var body: some View {
            VStack {
                List(students.list) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(item.name)")
                            
                        }
                        Text(item.email)
                    }
                }
            }
            .navigationTitle(module.code)
            .navigationBarTitleDisplayMode(.inline)
    }
    init(module: Module) {
        self.module = module
        students.getData(moduleDocumentId: module.id)
    }
}

//struct GroupStudentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupStudentsView(module:)
//    }
//}
