//
//  AddTopic.swift
//  Potential
//
//  Created by Elias Tabaka on 17/07/2023.
//

import SwiftUI

struct AddTopic: View {
    @Environment(\.dismiss) var dismiss
    @Binding var author: String
    @State private var topicsModel = DepartmentTopics()
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        Form {
            Section {
                TextField("", text: $title)
                
            } header: {
                Text("Title")
            }
            
            Section {
                TextEditor(text: $description)
            } header: {
                Text("Description")
            }
            
            Section{
                Button("Post") {
                    topicsModel.addData(title: title, description: description, author: author)
                    dismiss()
                }
            }
        }
            .onAppear() {
                topicsModel.getData()
            }
    }
}
