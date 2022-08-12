//
//  Persistence.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import CoreData

protocol CoreDataWrapper {
    func getContext() -> NSManagedObjectContext
    func getData(entityName: String) throws -> [NSManagedObject]
    func getData(entityName: String, predicate: NSPredicate) throws -> [NSManagedObject]
    func getData(entityName: String, predicate: NSPredicate, limit: Int) throws -> [NSManagedObject]
    func saveEntity(entity: NSManagedObject) throws
    func deleteEntity(entity: NSManagedObject) throws
}

struct PersistenceController: CoreDataWrapper {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CharacterArchive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() throws {
        do {
            try container.viewContext.save()
            
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    func getData(entityName: String) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func getData(entityName: String, predicate: NSPredicate) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func getData(entityName: String, predicate: NSPredicate, limit: Int) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func saveEntity(entity: NSManagedObject) throws{
        try save()
    }
    
    func deleteEntity(entity: NSManagedObject) throws {
        container.viewContext.delete(entity)
        try save()
    }
}
