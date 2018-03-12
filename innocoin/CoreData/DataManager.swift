//
//  DataManager.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import CoreData

/// Singleton class pattern
final class DataManager {
	
	static let shared = DataManager()

    private let modelName = "innova"
    
    private(set) lazy var context: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load Data Model")
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let sqlName = "\(self.modelName).sqlite"
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let coordinatorURL = documentDirectoryURL.appendingPathComponent(sqlName)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: coordinatorURL,
                                               options: nil)
        } catch let error as NSError {
            fatalError(error.localizedFailureReason ?? error.localizedDescription)
        }
        
        return coordinator
    }()
    
	private init() { }

    func save() {
        context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                debugPrint("Save CoreData failed: \(error.localizedFailureReason ?? error.localizedDescription)")
            }
        }

    }
}
