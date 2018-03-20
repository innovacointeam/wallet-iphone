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
    
    func openAddContact() {
        app.mainTabBar?.push(mainStoryboard.editContactViewController(), animated: true)
    }
    
    func edit(_ contact: Contact) {
        let controller = mainStoryboard.editContactViewController()
        controller.type = .editContact
        controller.contact = contact
        app.mainTabBar?.push(controller, animated: true)
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
