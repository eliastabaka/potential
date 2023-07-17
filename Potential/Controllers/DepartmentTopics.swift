//
//DepartmentTopics.swift
//  Potential
//
//  Created by Elias Tabaka on 16/07/2023.
//

import Foundation
import Firebase


class DepartmentTopics: ObservableObject {
    
    @Published var topics = [Topic]()
    
    func update(topicId: String, field: String, newValue: Int) {
        let db = Firestore.firestore()
        
        let topic = db.collection("departmentTopics").document(topicId)
        
        topic.updateData([field: newValue])
    }
    
    func addData(title: String, description: String, author: String) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("departmentTopics").addDocument(data: ["title": title, "author": author, "description": description, "votes": 0]) { error in
            
            if error == nil {
                self.getData()
            } else {
            }
        }
    }
    
    
    func getData() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("departmentTopics").order(by: "votes", descending: true).getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.topics = snapshot.documents.map { d in
                            //print(votes)
                            
                            // Create a Todo item for each document returned
                            return Topic(id: d.documentID, title: d["title"] as? String ?? "", description: d["description"] as? String ?? "", votes: d["votes"] as? Int ?? 0, author: d["author"] as? String ?? "")
                        }
                    }
                }
                else {
                    // Handle the error
                    
                }
            }
        }
        
        
        
        
    }

}
