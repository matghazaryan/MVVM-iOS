//
//  CoreDataManager.swift
//  Wether
//
//  Created by Hovhannes Stepanyan on 10/15/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let sInstance = CoreDataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it.
         */
        guard let containerPath = Bundle.main.paths(forResourcesOfType: "momd", inDirectory: nil).first else {
            /*
             * Probabely not created xcdatamodeld file
             * Check for its exist
            */
            fatalError()
        }
        let containerName = containerPath.deletingPathExtension.lastPathComponent
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                container.viewContext.mergePolicy = NSOverwriteMergePolicy
            }
        })
        return container
    }()
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveContext),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @objc
    func saveContext() {
        print("saving context...")
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func clearDataBase<T: NSManagedObject>(_ entity: T.Type) -> Bool {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: entity.fetchRequest())
        deleteRequest.resultType = .resultTypeStatusOnly
        guard let result = try? CoreDataManager.sInstance.viewContext.execute(deleteRequest) as? NSBatchDeleteResult else {
            return false
        }
        return result!.result as! Bool
    }
    
    class func clardWholeDataBases() -> Bool {
        guard let storeURL = Bundle(for: self)
            .url(forResource: "TestDataModel", withExtension: "momd"),
            let aModel = NSManagedObjectModel(contentsOf: storeURL) else {
                #if DEBUG
                print("error occourse in \(#file) lie \(#line)")
                #endif
                return false
        }
        var result = true
        for entity in aModel.entities {
            guard let clazz = NSClassFromString(entity.managedObjectClassName) else {
                #if DEBUG
                print("error occourse in \(#file) lie \(#line)")
                #endif
                return false
            }
            result = result && CoreDataManager.clearDataBase(clazz as! NSManagedObject.Type)
        }
        return result
    }
    
    class func objectForEntityType<T: NSManagedObject>(_ entity: T.Type, primaryKey: Any) throws -> T? {
        let fetchRequest = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", entity.primaryKey(), primaryKey as! CVarArg)
        let context = sInstance.viewContext
        guard let object = try context.execute(fetchRequest) as? NSAsynchronousFetchResult<T> else {
            let entityName = NSStringFromClass(entity)
            let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)!
            return T(entity: entityDescription, insertInto: context)
        }
        return object.finalResult?.first
    }
    
    class func fetchAllObjectsForType<T: NSManagedObject>(_ type: T.Type) throws -> [T] {
        let className = String(describing: type)
        let fetchRequest = NSFetchRequest<T>(entityName: className)
        let primaryKey = type.primaryKey()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: primaryKey, ascending: false)]
        let context = sInstance.viewContext
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: className, in: context)
        return try context.fetch(fetchRequest)
    }
    
    class func deleteObject<T: NSManagedObject>(_ entity: T.Type, primaryKey: Any, resultType: NSBatchDeleteRequestResultType) throws -> NSBatchDeleteResult {
        let fetchRequest = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", entity.primaryKey(), primaryKey as! CVarArg)
        let context = sInstance.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = resultType
        return try context.execute(deleteRequest) as! NSBatchDeleteResult
    }
}

extension NSManagedObject {
    @objc(primaryKey)
    class func primaryKey() -> String {
        return "id"
    }
}
