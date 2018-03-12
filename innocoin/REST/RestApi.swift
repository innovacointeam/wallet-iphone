//
//  RestApi.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

let defaultTimeoutInterval: TimeInterval = 60
let innoHost = URL(string: "http://159.89.109.174/api/v1.0")!

enum RestApi {
    
    case questionsList
    case signin(email: String, password: String)
    case signup(user: SignUpUser)
    case verifyToken(email: String)
    case profile(id: String)
    case changePassword(pincode: String, password: String, newPassword: String)
    case changePincode(password: String, pincode: String, newPincode: String)
    case resetPassword(email: String, question: String, answer: String)
    case resetPincode(question: String, answer: String)
    
    var method: String	 {
        switch self {
        case .questionsList,
             .profile:
            return "GET"
        case .signin,
             .signup,
             .resetPassword,
             .resetPincode,
             .verifyToken:
            return "POST"
        case .changePincode,
             .changePassword:
            return "PUT"
        }
    }
    
    private var path: String {
        switch self {
        case .questionsList:
            return "signup/security_questions"
        case .signup:
            return "signup"
        case .signin:
            return "login"
        case .resetPassword:
            return "users/profile/password_recovery"
        case .resetPincode:
            return  "users/profile/pincode_recovery"
        case .verifyToken:
            return "signup/verifytoken/send"
        case .profile(let id):
            return "users/\(id)"
        case .changePassword:
            return "users/profile/password"
        case .changePincode:
            return "users/profile/pincode"
        }
    }
    
    private var param: Data? {
        switch self {
        case .signup(let user):
            do {
                return try JSONEncoder().encode(user)
            } catch let error as NSError {
                debugPrint("Failed codable signup: \(error.localizedFailureReason ?? error.localizedDescription)")
                return nil
            }
        case .signin(let email, let password):
            let json = [
                "email": email,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .resetPassword(let email, let question, let answer):
            let json = [
                "email": email,
                "security_question": [
                    "question": question,
                    "answer": answer
                    ] as [String : Any]
            ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .resetPincode(let question, let answer):
            let json = [
                "security_question": [
                    "question": question,
                    "answer": answer
                    ] as [String : Any]
            ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .verifyToken(let email):
            let json = [
                "email": email
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .changePassword(let pincode, let password, let newPassword):
            let json = [
                "current_password": password,
                "pincode": pincode,
                "new_password": newPassword
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        case .changePincode(let password, let pincode, let newPincode):
            let json = [
                "current_pincode": pincode,
                "new_pincode": newPincode,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        default:
            return nil
        }
    }
    
    var statusCode: Int {
        switch self {
        case .verifyToken:
            return 202
        default:
            return 200
        }
    }
    
    var url: URL {
        return innoHost.appendingPathComponent(self.path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        request.timeoutInterval = defaultTimeoutInterval
        if self.method != "GET" {
            request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
            if let token = UserController.shared.token {
                let bearer = "Bearer \(token)"
                request.setValue(bearer, forHTTPHeaderField: "Authorization")
            }
        }
        request.httpMethod = self.method
        request.httpBody = self.param
        return request
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
        }
    }
    
    var debugDescription: String {
        let paramStr = param != nil ? String(data: param!, encoding: .utf8)! : "NULL"
        let text = """
            URL for request: \(self.url.absoluteString)
            Method: \(self.method)
            With param: \(paramStr)")
        """
        return text
    }
    
    
}
