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
    @State private var nameSharing = false
    @State private var me = Student(id: "", name: "", email: "")
    @State private var username: String
    @State private var email: String
    
    
    var body: some View {
        VStack {
            List {
                Section {
                    Toggle(isOn: $nameSharing) {
                        Text(nameSharing ? "Your name is visible." : "Your name is hidden.")
                    }.onChange(of: nameSharing) { value in
                        
                        
                        if me.email != email && nameSharing {
                            students.addData(name: username, email: email, moduleDocumentId: module.id)
                        } else if me.email == email && !nameSharing {
                            students.deleteData(module: module, studentDelete: me)
                            me = Student(id: "", name: "", email: "")
                        }
                        students.getData(moduleDocumentId: module.id)
                        
                    }
                }
                ForEach(students.list) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(item.name)")
                            
                        }
                        Text(item.email)
                    }
                }
                
            }
        }
        .navigationTitle(module.code)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            students.getData(moduleDocumentId: module.id)
            for student in students.list {
                if student.email == email {
                    me = student
                    nameSharing = true
                    break
                } else {
                    nameSharing = false
                }
            }
        }
    }
    init(username: String, email: String, module: Module) {
        self.module = module
        self.username = username
        self.email = email
        students.getData(moduleDocumentId: module.id)
        
    }
}

//struct GroupStudentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupStudentsView(module:)
//    }
//}
