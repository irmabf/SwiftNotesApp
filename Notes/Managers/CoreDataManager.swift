//
//  CoreDataManager.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import CoreData

final class CoreDataManager {
//  The only information we pass to the CoreDataManager class
//  is the name of the data model
  
//  Property for the modelName
  private let modelName: String
//  Designated Initializer
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  private(set) lazy var managedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    return managedObjectContext
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Unable to find data model")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to load data model")
    }
    
    return managedObjectModel
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let fileManager = FileManager.default
    let storeName = "\(self.modelName).sqlite"
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
    do{
      try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
      
    }catch{
      fatalError("Unable to add persistent store")
    }
    
    return persistentStoreCoordinator
    
  }()
  
}











