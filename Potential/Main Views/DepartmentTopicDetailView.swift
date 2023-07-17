//
//  DepartmentTopicDetailView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/07/2023.
//

import SwiftUI

struct DepartmentTopicDetailView: View {
    let topic: Topic
    @ObservedObject var topicsModel = DepartmentTopics()
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        Form {
            Section {
                Text(topic.title)
            } header: {
                Text("Title")
            }
            
            Section {
                Text(topic.description)
            } header: {
                Text("Description")
            }
            
            Section {
                Text(topic.author)
            } header: {
                Text("Author")
            }
            
            Section {
                Button("Vote up") {
                    topicsModel.update(topicId: topic.id, field: "votes", newValue: topic.votes + 1)
                    dismiss()
                }
            }
            
            Section {
                
                Button("Vote down") {
                    topicsModel.update(topicId: topic.id, field: "votes", newValue: topic.votes - 1)
                    dismiss()
                }
            }
            
            
        }
    }
}
