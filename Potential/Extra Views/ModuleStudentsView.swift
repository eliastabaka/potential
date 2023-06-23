//
//  ModuleNamesView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI

struct ModuleStudentsView: View {
    let module: ModuleExt
    @ObservedObject var students = ViewStudent()
    @State private var nameSharing = false
    @State private var currentStudent = StudentExt(id: "", name: "", email: "")
    @Binding private var mainUsername: String
    @Binding private var mainEmail: String
    
    
    var body: some View {
        VStack {
            List {
                Section {
                    // Name visibility
                    Toggle(isOn: $nameSharing) {
                        Text(nameSharing ? "Your name is visible." : "Your name is hidden.")
                    }.onChange(of: nameSharing) { value in
                        
                        // when student not visible
                        if currentStudent.email != mainEmail && nameSharing {
                            let studentID = students.addData(name: mainUsername, email: mainEmail, moduleDocumentId: module.id)
                            students.getData(moduleDocumentId: module.id)
                            currentStudent = StudentExt(id: studentID, name: mainUsername, email: mainEmail)
                            
                            // when student is visible
                        } else if currentStudent.email == mainEmail && !nameSharing {
                            students.deleteData(module: module, studentDelete: currentStudent)
                            currentStudent = StudentExt(id: "", name: "", email: "")
                        }
                        students.getData(moduleDocumentId: module.id)
                    }
                }
                
                // list of students
                ForEach(students.list) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.name)")
                            .foregroundColor(item.email == mainEmail ? .green : .primary)
                        Text(item.email)
                            .foregroundColor(item.email == mainEmail ? .green : .primary)
                    }
                }
            }
        }
        .navigationTitle(module.code)
        .navigationBarTitleDisplayMode(.inline)
        
        // updates the view with the database
        .onAppear() {
            students.getData(moduleDocumentId: module.id)
            for student in students.list {
                if student.email == mainEmail {
                    currentStudent = student
                    nameSharing = true
                    break
                } else {
                    nameSharing = false
                }
            }
        }
    }
    
    init(username: Binding<String>, email: Binding<String>, module: ModuleExt) {
        self.module = module
        self._mainUsername = username
        self._mainEmail = email
        students.getData(moduleDocumentId: module.id)
        
    }
}
