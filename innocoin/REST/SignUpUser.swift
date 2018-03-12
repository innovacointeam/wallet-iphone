//
//  SecurityQuestion.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct SecurityQuestion: Codable {
    
    var question: String
    var answer: String
    
}

struct SignUpUser: Codable {
    
    var email: String
    var password: String
    var pincode: String
    var securityQuestion: SecurityQuestion
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case pincode
        case securityQuestion = "security_question"
    }
    
    /// Validate filed structure to SignUp
    ///
    /// - Returns: nil if all OK elsewhere Validation message
    func validate() -> String? {
        if !validateEmail() {
            return NSLocalizedString("Incorrect email format", comment: "")
        }
        if !validatePassowrd() {
            return NSLocalizedString("Passowrd must be at least 7 symbols", comment: "")
        }
        
        if !validatePin() {
            return NSLocalizedString("Pincode must be at 6 digits", comment: "")
        }
        
        if !validateQuestion() {
            return NSLocalizedString("Please select security question", comment: "")
        }
        
        if securityQuestion.answer.count == 0 {
            return NSLocalizedString("Please enter security answer", comment: "")
        }
        
        return nil
    }
    
    
    /// Validate Security Question
    ///
    /// - Note: Question must be from Security Qeustions List, lodaded from server
    /// - Returns: Validate result
    func validateQuestion() -> Bool {
        return LoginController.shared.questions.contains(securityQuestion.question)
    }
    
    
    /// Validate pincode
    ///
    /// - Note: Pincode must be excatly 6 digit
    /// - Returns: validation result
    func validatePin() -> Bool {
        let pniRegex = "^[0-9]{6}$"
        let pinTest = NSPredicate(format:"SELF MATCHES %@", pniRegex)
        return pinTest.evaluate(with: pincode)
    }
    
    /// Validate Password
    ///
    /// - Note: Password must be at least 7 symbols
    /// - Returns: validate result
    func validatePassowrd() -> Bool {
        return password.count > 6
    }
    
    /// Validate Email by regex
    ///
    /// - Note: accepted only latin symbols. Domain extension must be at least 2 symbols
    /// - Returns: validate result
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
