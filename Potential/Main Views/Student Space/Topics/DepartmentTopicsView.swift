//
//  DepartmentTopicsView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/07/2023.
//

import SwiftUI

struct DepartmentTopicsView: View {
    @ObservedObject var topicsModel = DepartmentTopics()
    @State private var showingAdd = false
    @Binding var author: String
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(searchResults) { topic in
                NavigationLink {
                    DepartmentTopicDetailView(topic: topic)
                } label: {
                    HStack {
                        Text(topic.title)
                        Spacer()
                        Text("\(topic.votes)")
                    }
                }
                
                
                
            }
        }
        .searchable(text: $searchText, prompt: "Look for a specific content")
        .onAppear() {
            topicsModel.getData()
        }
        .refreshable {
            topicsModel.getData()
        }
        .navigationTitle("Topics")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAdd = true
                } label: {
                    Label("Settings", systemImage: "plus")
                }
            }

        }
        .sheet(isPresented: $showingAdd, onDismiss: {
                topicsModel.getData()
        }, content: {
            withAnimation {
                AddTopic(author: $author)
            }
        })
    }
    
    func countVotes(_ voters: [Vote]) -> Int {
        var counter = 0
        
        for voter in voters {
            counter += voter.value
        }
        
        return counter
    }
    
    var searchResults: [Topic] {
            if searchText.isEmpty {
                return topicsModel.topics
            } else {
                return topicsModel.topics.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased()) }
            }
        }
}
