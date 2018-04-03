//
//  RESTController.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

/// Singleton class pattern
class RESTController: NSObject {
	
	static let shared = RESTController()
    private var reachability: Reachability!
    
    private lazy var session: URLSession = {
        var newSession = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: self,
                                    delegateQueue: nil)
        return newSession
    }()
    
    private override init() {
        reachability = Reachability(hostname: InnovaConstanst.innoHost.absoluteString)
    }
    
    var online: Bool {
        guard reachability != nil else {
            return false
        }
        return reachability.connection != .none
    }
    
    var startPage = 0
    
    deinit {
        debugPrint("REST Controller deinit")
    }
    
    func getQuestions(completion: @escaping (ServerResponse)->()) {
        var request = URLRequest(url: RestApi.questionsList.url)
        request.httpMethod = RestApi.questionsList.method
        request.timeoutInterval = 60
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil,
                let data = data,
                let httpResponse = response as? HTTPURLResponse else {
                    completion(.error(reason: error?.localizedDescription, title: "Server error"))
                return
            }
            debugPrint("Get question list from server")
            completion(.success(data: data, code: httpResponse.statusCode))
        }
        task.resume()
    }
    
    func price(completion: @escaping (ServerResponse)->()) {
        call(RestApi.price, completion: completion)
    }
    
    func makeAnonymous(completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.setAnonymous
        call(rest, completion: completion)
    }
    
    func makePublic(completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.setPublic
        call(rest, completion: completion)
    }
    
    func resetPassword(email: String, question: String, answer: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.resetPassword(email: email, question: question, answer: answer)
        call(rest, completion: completion)
    }
    
    func resetPincode(question: String, answer: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.resetPincode(question: question, answer: answer)
        call(rest, completion: completion)
    }
    
    func changePassword(pincode: String, password: String, newPassword: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.changePassword(pincode: pincode, password: password, newPassword: newPassword)
        call(rest, completion: completion)
    }
    
    func changePincode(password: String, pincode: String, newPincode: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.changePincode(password: password, pincode: pincode, newPincode: newPincode)
        call(rest, completion: completion)
    }
    
    func signin(email: String, password: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.signin(email: email, password: password)
        call(rest, completion: completion)
    }
    
    func signup(user: SignUpUser, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.signup(user: user)
        call(rest, completion: completion)
    }
    
    func  verify(completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.verifyToken(email: UserController.shared.profile.email)
        call(rest, completion: completion)
    }
    
    
    func call(_ rest: RestAPIProtocol, completion: @escaping (ServerResponse)->()) {
        guard reachability.connection != .none else {
            completion(.error(reason: "Internet connection unreachable. Please check you settings", title: "Internet Error"))
            return
        }
        debugPrint(rest)
        let task = session.dataTask(with: rest.urlRequest) { data, response, error in
            guard error == nil,
                let data = data,
                let httpResponse = response as? HTTPURLResponse else {
                    completion(.error(reason: error?.localizedDescription, title: "Server Error"))
                    return
            }
            #if DEBUG
                let jsonString = String(data: data, encoding: .utf8)
                debugPrint("\(rest.description) answer: \(jsonString ?? "")")
            #endif
            switch httpResponse.statusCode {
            case 200..<300:
                completion(.success(data: data, code: httpResponse.statusCode))
            case 401:
                // First check err code
                if let responseError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    if responseError.error.error_code == 4011 {
                        completion(.error(reason: "Authorisation token expired.", title: "User Error"))
                        // Try to login one more time
                        LoginController.shared.tokenExpired()
                    } else {
                        completion(.error(reason: responseError.error.reason, title: "User Error"))
                    }
                }
            default:
                let responseError = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(.error(reason: responseError?.error.reason, title: httpResponse.statusCode == 500 ? "Server Error" : "User Error"))
            }
        }
        task.resume()
    }
}

extension RESTController: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Within your authentication handler delegate method, you should check to see if the challenge protection space has an authentication type of NSURLAuthenticationMethodServerTrust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let proposedCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, proposedCredential)
        }
    }
    
}

