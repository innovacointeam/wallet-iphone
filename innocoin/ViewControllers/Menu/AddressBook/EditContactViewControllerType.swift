//
//  EditContactViewControllerType.swift
//  innocoin
//
//  Created by Yuri Drigin on 12.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum EditContactViewControllerType {
    case newContact
    case editContact
    
    var title: String {
        switch self {
        case .newContact:
            return "Add Contact"
        case .editContact:
            return "Edit Contact"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .newContact:
            return "Create"
        case .editContact:
            return "Save"
        }
    }
}
