//
//  CoreDataManager.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    /*
     * CompletionHandler: for handling success and faliure case.
     */
    typealias CompletionHandler = (_ success: Bool, _ error: String, _ result: [ListModel]) -> Void
    
    /*
     * We are creating a static let, so that sharedManager have same instance and can not be changed.
     */
    static let sharedManager = CoreDataManager()
    
    /*
     * Prevent clients from creating another instance.
     * Using private keyword, so that this class can not be initialize mistakenly. If at some place you will try to initialize it again you will get compile time error.
     */
    
    private init() {}
    
    /*
     * Initializing NSPersistentContainer.
     * Initializing core data stack lazily. persistentContainer object will be initialized only when it's' needed.
     */
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: constants.coreDataStack.DATABASE_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /*
     * Save context method will save our uncommitted changes in core data store.
     */
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
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
    
    /*
     * Convert NSManagedObject in to Json Array.
     * Convert Json array into Model
     */
    
    func convertToJSONArray(moArray: [NSManagedObject]) -> [ListModel] {
        var models: [ListModel] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            models.append(ListModel.init(dict: dict))
        }
        return models
    }
    
    /*
     * Retrieve All user information from table.
     */
    
    func fetchAllSavedInformationFromDB(completionHandler: CompletionHandler) {
        var people = [NSManagedObject]()
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: constants.coreDataStack.TABLE_NAME)
        do {
            people = try managedContext.fetch(fetchRequest)
            completionHandler(true, constants.message.ALL, convertToJSONArray(moArray: people))
        } catch let error as NSError {
            completionHandler(false, "Could not fetch. \(error), \(error.userInfo)", [])
        }
    }
    
    /*
     * Save singel user information in table.
     */
    
    func saveMedicineInformationInEntity(medicineName: String, medicineDescription: String, price: String, quantity: String, completionHandler: CompletionHandler)  {
        let lPrice = Double(price)
        let quant = Int64(quantity)
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: constants.coreDataStack.TABLE_NAME, in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(medicineName, forKeyPath: constants.dbKey.KEY_NAME)
        person.setValue(medicineDescription, forKeyPath: constants.dbKey.KEY_DESCRIPTION)
        person.setValue(lPrice, forKeyPath: constants.dbKey.KEY_PRICE)
        person.setValue(quant, forKeyPath: constants.dbKey.KEY_QUANTITY)
        do {
            try managedContext.save()
            completionHandler(true, constants.message.SAVE, convertToJSONArray(moArray: [person]))
        } catch let error as NSError {
            completionHandler(false, "Could not save. \(error), \(error.userInfo)", convertToJSONArray(moArray: []))
        }
    }
    
    /*
     * Update singel user information in table.
     */
    
    func updateMedicineInformationInEntity(medicineName: String, updatedMedicineName: String, updatedMedicineDescription: String, updatedPrice: String, updatedQuantity: String, completionHandler: CompletionHandler) {
        let lPrice = Double(updatedPrice)
        let quant = Int64(updatedQuantity)
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: constants.coreDataStack.TABLE_NAME)
        fetchRequest.predicate = NSPredicate(format: "medicineName = %@", medicineName)
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(updatedMedicineName, forKey: constants.dbKey.KEY_NAME)
            objectUpdate.setValue(updatedMedicineDescription, forKey: constants.dbKey.KEY_DESCRIPTION)
            objectUpdate.setValue(quant, forKey: constants.dbKey.KEY_QUANTITY)
            objectUpdate.setValue(lPrice, forKey: constants.dbKey.KEY_PRICE)
            do {
                try managedContext.save()
                completionHandler(true, constants.message.UPDATE, convertToJSONArray(moArray: [objectUpdate]))
            } catch let error as NSError {
                completionHandler(false, "Could not save. \(error), \(error.userInfo)", convertToJSONArray(moArray: []))
                print(error)
            }
        } catch let error as NSError {
            completionHandler(false, "Could not save. \(error), \(error.userInfo)", convertToJSONArray(moArray: []))
            print(error)
        }
    }
    
    func deleteData(medicineName: String, completionHandler: CompletionHandler) {
         let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constants.coreDataStack.TABLE_NAME)
        fetchRequest.predicate = NSPredicate(format: "medicineName = %@", medicineName)
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
                completionHandler(true, constants.message.DELETE, convertToJSONArray(moArray: []))
            }
            catch let error as NSError {
                completionHandler(false, "Could not save. \(error), \(error.userInfo)", convertToJSONArray(moArray: []))
            }
        } catch let error as NSError {
            completionHandler(false, "Could not save. \(error), \(error.userInfo)", convertToJSONArray(moArray: []))
        }
    }
}
