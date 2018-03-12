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
    
    func addressBookEmptyViewController() -> AddressbookEmptyViewController  {
       return self.instantiateViewController(withIdentifier: "AddressbookEmptyViewController") as! AddressbookEmptyViewController
    }
    
    func addContactViewController() -> AddContactViewController {
        return self.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
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
