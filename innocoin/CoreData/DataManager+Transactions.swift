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
    
    func updateSended(transactions: [InnovaTransaction]) {
        debugPrint("Update sended transactions: \(transactions.count)")
        for transaction in transactions {
            let entity = getTransaction(by: transaction.id) ?? Transaction(entity: Transaction.entity(), insertInto: context)
            entity.send(transaction)
        }
        save()
    }
    
    func updateReceived(transactions: [InnovaTransaction]) {
        debugPrint("Update received transactions: \(transactions.count)")
        for transaction in transactions {
            let entity = getTransaction(by: transaction.id) ?? Transaction(entity: Transaction.entity(), insertInto: context)
            entity.received(transaction)
        }
        save()
    }
    
    func transactionsFetchController() ->  NSFetchedResultsController<Transaction> {
        let fetch: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timereceived", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetch,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
