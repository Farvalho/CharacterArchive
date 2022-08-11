//
//  Persistence.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CharacterArchive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        do {
            try container.viewContext.save()
            
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
}
