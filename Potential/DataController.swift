//
//  DataController.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Potential" )
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                
            }
        }
    }
}
