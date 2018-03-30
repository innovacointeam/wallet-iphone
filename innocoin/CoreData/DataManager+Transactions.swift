//
//  DataManager+Transactions.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
    
    func getTransaction(by id: String) -> Transaction? {
        let fetch: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(fetch).first
        } catch let error as NSError {
            debugPrint("Fetch Transaction from CoreData failed: \(error.localizedFailureReason ?? error.localizedDescription)")
            return nil
        }

    }
    
    func update(transactions: [InnovaTransaction]) {
        guard transactions.count > 0 else {
            return
        }
        for transaction in transactions {
            let entity = getTransaction(by: transaction.id) ?? Transaction(entity: Transaction.entity(), insertInto: context)
            entity.populate(transaction)
        }
        save()
    }
    
    
    func transactionsFetchController() ->  NSFetchedResultsController<Transaction> {
        let fetch: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timereceived", ascending: false)]
        fetch.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: fetch,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
