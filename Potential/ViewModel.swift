//
//  ViewModel.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    @Published var list = [Module]()
    
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
                            return Module(id: d.documentID, code: d["code"] as? String ?? "", name: d["name"] as? String ?? "")
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
