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
            Text(topic.title)
            Text(topic.description)
            Text(topic.author)
            Button("Update") {
                topicsModel.update(topicId: topic.id, field: "votes", newValue: topic.votes + 1)
                dismiss()
            }
        }
    }
}
