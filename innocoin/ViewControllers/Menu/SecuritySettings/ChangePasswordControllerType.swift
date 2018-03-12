//
//  ChangePasswordControllerType.swift
//  innocoin
//
//  Created by Yuri Drigin on 09.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

public enum ChangePasswordControllerType {
    case password
    case pincode
    
    var title: String {
        switch self {
        case .password:
            return "Change Password"
        case .pincode:
            return "Change Pincode"
        }
    }
    
    var currentPasswordLabel: String {
        switch self {
        case .password:
            return "Pincode"
        case .pincode:
            return "Password"
        }
    }
    
    var newPasswordLabel: String {
        switch self {
        case .password:
            return "Current password"
        case .pincode:
            return "Current pincode"
        }
    }
    
    var retypePasswordLabel: String {
        switch self {
        case .password:
            return "New password"
        case .pincode:
            return "New pincode"
        }
    }
    
    var currentPasswordPlaceholder: String {
        switch self {
        case .password:
            return "enter pincode"
        case .pincode:
            return "enter password"
        }
    }
    
    var newPasswordPlaceholder: String {
        switch self {
        case .password:
            return "enter current password"
        case .pincode:
            return "enter current pincode"
        }
    }
    
    var retypePasswordPlaceholder: String {
        switch self {
        case .password:
            return "enter new password"
        case .pincode:
            return "enter new pincode"
        }
    }
    

}
