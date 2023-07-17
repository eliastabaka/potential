//
//  DepartmentTopicsView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/07/2023.
//

import SwiftUI

struct DepartmentTopicsView: View {
    @ObservedObject var topicsModel = DepartmentTopics()
    
    var body: some View {
        List {
            ForEach(topicsModel.topics) { topic in
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
        }.onAppear() {
            topicsModel.getData()
        }
        .refreshable {
            topicsModel.getData()
        }
    }
    
    func countVotes(_ voters: [Vote]) -> Int {
        var counter = 0
        
        for voter in voters {
            counter += voter.value
        }
        
        return counter
    }
}

struct DepartmentTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentTopicsView()
    }
}
