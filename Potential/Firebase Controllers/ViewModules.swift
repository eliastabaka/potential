//
//  ViewModules.swift
//  Potential
//
//  Created by Elias Tabaka on 14/06/2023.
//

import Foundation
import Firebase

class ViewModules: ObservableObject {
    
    @Published var list = [ModuleExt]()
    @Published var assessmentList = [AssessmentExt]()
    
    func getData() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("modules").order(by: "code").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return ModuleExt(id: d.documentID, code: d["code"] as? String ?? "", name: d["name"] as? String ?? "", credits: d["credits"] as? Int ?? 0)
                        }
                    }
                }
                else {
                    // Handle the error
                    
                }
            }
        }
        
    }
    
    
    func getAssessmentData(moduleDocumentId: String) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("modules").document(moduleDocumentId).collection("assessments").order(by: "name").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.assessmentList = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return AssessmentExt(id: d.documentID, name: d["name"] as? String ?? "", percentage: d["percentage"] as? Int ?? 0)
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
