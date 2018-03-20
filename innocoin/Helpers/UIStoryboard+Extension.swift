//
//  UIStoryboard+Extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static var transactionDetailsViewController: TransactionDetailsViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as! TransactionDetailsViewController
    }
    
    func loginViewController() -> LoginNavigationController {
        return self.instantiateViewController(withIdentifier: "LoginNavigationController") as! LoginNavigationController
    }
    
    func addressBookEmptyViewController() -> AddressbookEmptyViewController  {
       return self.instantiateViewController(withIdentifier: "AddressbookEmptyViewController") as! AddressbookEmptyViewController
    }
    
    func editContactViewController() -> EditContactViewController {
        return self.instantiateViewController(withIdentifier: "EditContactViewController") as! EditContactViewController
    }
    
    func contactsTableViewController() -> ContactsTableViewController {
        return self.instantiateViewController(withIdentifier: "ContactsTableViewController") as! ContactsTableViewController
    }
    
    func previewContactViewController() -> PreviewContactViewController {
        return self.instantiateViewController(withIdentifier: "PreviewContactViewController") as! PreviewContactViewController
    }
    
    func changePasswordViewController() -> ChangePasswordViewController {
        return self.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
    }
}
