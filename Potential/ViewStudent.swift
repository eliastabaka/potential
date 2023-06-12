//
//  ViewStudent.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import Foundation
import Firebase

class ViewStudent: ObservableObject {
    
    @Published var list = [Student]()
    
    func deleteData(moduleDelete: Module) {
        let db = Firestore.firestore()
        db.collection("students").document(moduleDelete.id).delete { error in
            if error == nil {
                
                DispatchQueue.main.async {
                    self.list.removeAll { module in
                        return module.id == moduleDelete.id
                    }
                }
            }
        }
    }
    
    func addData(code: String, name: String) {
        let db = Firestore.firestore()
        db.collection("students").addDocument(data: ["code": code, "name": name]) { error in
            
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
        db.collection("students").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return Student(id: d.documentID, firstName: d["firstName"] as? String ?? "", lastName: d["lastName"] as? String ?? "", email: d["email"] as? String ?? "")
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
