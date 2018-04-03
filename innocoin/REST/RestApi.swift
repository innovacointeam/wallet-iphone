//
//  RestApi.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

enum RestApi: RestAPIProtocol {
    
    var queryItems: [URLQueryItem]? {
        return nil
    }

    case questionsList
    case signin(email: String, password: String)
    case signup(user: SignUpUser)
    case verifyToken(email: String)
    case profile(id: String)
    case changePassword(pincode: String, password: String, newPassword: String)
    case changePincode(password: String, pincode: String, newPincode: String)
    case resetPassword(email: String, question: String, answer: String)
    case resetPincode(question: String, answer: String)
    case setAnonymous
    case setPublic
    case price
    
    var method: String	 {
        switch self {
        case .questionsList,
             .price,
             .profile:
            return "GET"
        case .signin,
             .signup,
             .resetPassword,
             .resetPincode,
             .verifyToken:
            return "POST"
        case .changePincode,
             .setPublic,
             .setAnonymous,
             .changePassword:
            return "PUT"
        }
    }
    
    var path: String {
        switch self {
        case .questionsList:
            return "/signup/security_questions"
        case .signup:
            return "/signup"
        case .signin:
            return "/login"
        case .resetPassword:
            return "/users/profile/password_recovery"
        case .resetPincode:
            return  "/users/profile/pincode_recovery"
        case .verifyToken:
            return "/signup/verifytoken/send"
        case .profile(let id):
            return "/users/\(id)"
        case .changePassword:
            return "/users/profile/password"
        case .changePincode:
            return "/users/profile/pincode"
        case .setAnonymous:
            return "/users/profile/anonymous"
        case .setPublic:
            return "/users/profile/public"
        case .price:
            return "/market/price"
        }
    }
    
    var param: Parameters {
        var json = Parameters()
        switch self {
        case .signup(let user):
            json["email"] = user.email
            json["password"] = user.password
            json["pincode"] = user.pincode
            json["security_question"] = [
                "question": user.securityQuestion.question,
                "answer": user.securityQuestion.answer
                ] as Parameters
        case .signin(let email, let password):
            json["email"] = email
            json["password"] = password
        case .resetPassword(let email, let question, let answer):
            json["email"] = email
            json["security_question"] = [
                    "question": question,
                    "answer": answer
                    ] as Parameters
        case .resetPincode(let question, let answer):
            json["security_question"] = [
                    "question": question,
                    "answer": answer
                    ] as Parameters
        case .verifyToken(let email):
            json["email"] = email
        case .changePassword(let pincode, let password, let newPassword):
            json["current_password"] = password
            json["pincode"] = pincode
            json["new_password"] = newPassword
        case .changePincode(let password, let pincode, let newPincode):
            json["current_pincode"] = pincode
            json["new_pincode"] = newPincode
            json["password"] = password
        default:
            break
        }
        return json
    }
}

extension RestApi: CustomDebugStringConvertible, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .questionsList:
            return "Request Question List"
        case .signin:
            return "Login to server"
        case .signup:
            return "SignUp new user"
        case .resetPassword:
            return "Request to reset password"
        case .resetPincode:
            return "Request to reset pincode"
        case .verifyToken:
            return "Verify login token"
        case .profile:
            return "Request user profile"
        case .changePassword:
            return "Try to change password"
        case .changePincode:
            return "Try to change pincode"
        case .setAnonymous:
            return "Request to make profile anonymous"
        case .setPublic:
            return "Request to make profile public"
        case .price:
            return "Request market Innova price"
        }
    }
}
