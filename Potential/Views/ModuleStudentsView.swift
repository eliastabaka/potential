//
//  ModuleNamesView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI

struct ModuleStudentsView: View {
    let module: Module
    @ObservedObject var students = ViewStudent()
    @State private var nameSharing = false
    @State private var currentStudent = Student(id: "", name: "", email: "")
    @State private var mainUsername: String
    @State private var mainEmail: String
    
    
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
                            currentStudent = Student(id: studentID, name: mainUsername, email: mainEmail)
                            
                            // when student is visible
                        } else if currentStudent.email == mainEmail && !nameSharing {
                            students.deleteData(module: module, studentDelete: currentStudent)
                            currentStudent = Student(id: "", name: "", email: "")
                        }
                        students.getData(moduleDocumentId: module.id)
                    }
                }
                
                // list of students
                ForEach(students.list) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.name)")
                        Text(item.email)
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
    
    init(username: String, email: String, module: Module) {
        self.module = module
        self.mainUsername = username
        self.mainEmail = email
        students.getData(moduleDocumentId: module.id)
        
    }
}
