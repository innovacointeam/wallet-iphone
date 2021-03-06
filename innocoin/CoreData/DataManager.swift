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
    
    public var selectedAddressToSend: String = ""
    
    private let walletJSONKey = "com.innova.WalletJSON"
    private let pendingJSONKey = "com.innova.PendingJSON"
    private let sequrityQuestionJSON = "com.innova.SequrityQuestionsJSON"
    
    var lastPending: Data? {
        get {
            return UserDefaults.standard.data(forKey: pendingJSONKey)
        }
        set {
            guard let data = newValue else {
                return
            }
            UserDefaults.standard.set(data, forKey: pendingJSONKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    var lastWallet: Data? {
        get {
            return UserDefaults.standard.data(forKey: walletJSONKey)
        }
        set {
            guard let data = newValue else {
                return
            }
            UserDefaults.standard.set(data, forKey: walletJSONKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    var sequrityQuestion: Data? {
        get {
            return UserDefaults.standard.data(forKey: sequrityQuestionJSON)
        }
        set {
            guard let data = sequrityQuestion else {
                return
            }
            UserDefaults.standard.set(data, forKey: sequrityQuestionJSON)
            UserDefaults.standard.synchronize()
        }
    }
    
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
    
    private lazy var coordinatorURL: URL = {
        let fileManager = FileManager.default
        let sqlName = "\(self.modelName).sqlite"
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectoryURL.appendingPathComponent(sqlName)
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
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
    
    func clear() {
        do {
            let store = persistentStoreCoordinator.persistentStores[0]
            try persistentStoreCoordinator.remove(store)
            try addCoordinator()
        } catch let error {
            debugPrint(error)
        }
        UserDefaults.standard.removeObject(forKey: walletJSONKey)
        UserDefaults.standard.removeObject(forKey: pendingJSONKey)
    }
    
    private func addCoordinator() throws {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                          configurationName: nil,
                                                          at: coordinatorURL,
                                                          options: nil)
    }
}
