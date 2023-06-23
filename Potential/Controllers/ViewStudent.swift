//
//  ViewStudent.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import Foundation
import Firebase

class ViewStudent: ObservableObject {
    
    @Published var list = [StudentExt]()
    
    func deleteData(module: ModuleExt, studentDelete: StudentExt) {
        let db = Firestore.firestore()
        db.collection("modules").document(module.id).collection("students").document(studentDelete.id).delete { error in
            if error == nil {
                
                DispatchQueue.main.async {
                    self.list.removeAll { student in
                        return student.id == studentDelete.id
                    }
                }
            }
        }
    }
    
    func addData(name: String, email: String, moduleDocumentId: String) -> String {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("modules").document(moduleDocumentId).collection("students").addDocument(data: ["name": name, "email": email]) { error in
            
            if error == nil {
                self.getData(moduleDocumentId: moduleDocumentId)
            } else {
            }
        }
        return ref!.documentID
    }
    
    func getData(moduleDocumentId: String) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("modules").document(moduleDocumentId).collection("students").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return StudentExt(id: d.documentID, name: d["name"] as? String ?? "", email: d["email"] as? String ?? "")
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
