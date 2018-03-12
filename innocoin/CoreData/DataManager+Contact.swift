//
//  DataManager+Contact.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
    
    func addContact(_ name: String, innovaAddress: String, completion: ((Bool, String?)->())? ) {
        guard !checkContactExist(name, wallet: innovaAddress) else {
            completion?(false, "Contact with name \(name) or innova address \(innovaAddress) exist")
            return
        }
        let newContact = Contact(entity: Contact.entity(), insertInto: context)
        newContact.fullName = name
        newContact.wallet = innovaAddress
        save()
        
        completion?(true, nil)
    }
    
    func checkContactExist(_ name: String, wallet: String) -> Bool {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.predicate = NSPredicate(format: "fullName == %@ OR wallet == %@", name, wallet)
        do {
            let contact = try context.fetch(request).first
            return contact != nil
        } catch let error as NSError {
            debugPrint("Fetch Contact failed \(error.localizedFailureReason ?? error.localizedDescription)")
            return false
        }
    }
    
    func contacts() -> [Contact] {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            debugPrint("Fetch Contact failed \(error.localizedFailureReason ?? error.localizedDescription)")
            return []
        }
    }
    
    func delete(contact: Contact) {
        context.delete(contact)
        save()
    }
    
    func contactsFetchController() ->  NSFetchedResultsController<Contact> {
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetch,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        return controller
    }
    
}
