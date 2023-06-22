//
//  ViewModel.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    @Published var list = [ModuleExt]()
    
    func deleteData(moduleDelete: ModuleExt) {
        let db = Firestore.firestore()
        db.collection("modules").document(moduleDelete.id).delete { error in
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
        db.collection("modules").addDocument(data: ["code": code, "name": name]) { error in
            
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
        db.collection("modules").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return ModuleExt(id: d.documentID, code: d["code"] as? String ?? "", name: d["name"] as? String ?? "")
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
