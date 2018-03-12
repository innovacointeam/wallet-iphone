//
//  RouterViewControllers.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

/// Singleton class pattern
class RouterViewControllers {
	
	static let shared = RouterViewControllers()
    private let mainStoryboard: UIStoryboard
    private let app: InnocoinApp!
    
	private init() {
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        app = UIApplication.shared.delegate as? InnocoinApp
    }

//    /// Close Add Contact View Controller.
//    ///
//    /// if views in navigation controller - pop it, else dismiss
//    ///
//    /// - Note: Check if has any contact in Database open - ContactsTableView elsewhere EmptyContactView
//    /// - Parameter addContact: Current AddContactViewController
//    func close(addContact: AddContactViewController)  {
//        guard let navVC = addContact.navigationController else {
//            addContact.dismiss(animated: false, completion: nil)
//            return
//        }
//        navVC.popViewController(animated: false)
//        if navVC.visibleViewController is AddressbookEmptyViewController {
//            navVC.popViewController(animated: false)
//        }
//        navVC.visibleViewController?.navigationItem.title = ""
//        let contacts = DataManager.shared.contacts()
//        if contacts.count > 0 {
//            navVC.pushViewController(mainStoryboard.contactsTableViewController(), animated: true)
//        } else {
//            navVC.pushViewController(mainStoryboard.addressBookEmptyViewController(), animated: true)
//        }
//    }
    
    func openResetPincode() {
        let controller = ResetPincodeViewController()
        app.mainTabBar?.push(controller, animated: true)
    }
    
    func openChangePassword() {
        let controller = mainStoryboard.changePasswordViewController()
        controller.type = .password
        app.mainTabBar?.push(controller, animated: true)
    }
    
    func openChangePincode() {
        let controller = mainStoryboard.changePasswordViewController()
        controller.type = .pincode
        app.mainTabBar?.push(controller, animated: true)
    }
    
    func openAddressBook() {
        app.mainTabBar?.push(mainStoryboard.contactsTableViewController(), animated: true)
    }
    
    func preview(contact: Contact) {
        let controller = mainStoryboard.previewContactViewController()
        controller.contact = contact
        app.mainTabBar?.push(controller, animated: true)
    }
    
    func pop() {
        app.mainTabBar?.pop()
    }
}
