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
	
    private lazy var session: URLSession = {
        var newSession = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: self,
                                    delegateQueue: nil)
        return newSession
    }()
    
    private override init() { }
    
    deinit {
        debugPrint("REST Controller deinit")
    }
    
    func getQuestions(completion: @escaping (ServerResponse)->()) {
        var request = URLRequest(url: RestApi.questionsList.url)
        request.httpMethod = RestApi.questionsList.method
        request.timeoutInterval = 10
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil,
                let data = data,
                let httpResponse = response as? HTTPURLResponse else {
                    completion(.error(reason: error?.localizedDescription, code: 0))
                return
            }
            
            completion(.success(data: data, code: httpResponse.statusCode))
        }
        task.resume()
    }
    
    func signin(email: String, password: String, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.signin(email: email, password: password)
        send(rest, completion: completion)
    }
    
    func signup(user: SignUpUser, completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.signup(user: user)
        send(rest, completion: completion)
    }
    
    func  verify(completion: @escaping (ServerResponse)->()) {
        let rest = RestApi.verifyToken(email: UserController.shared.profile.email)
        send(rest, completion: completion)
    }
    
    private func send(_ rest: RestApi, completion: @escaping (ServerResponse)->()) {
        debugPrint("\(rest.description): \(rest.debugDescription)")
        let task = session.dataTask(with: rest.urlRequest) { data, response, error in
            guard error == nil,
                let data = data,
                let httpResponse = response as? HTTPURLResponse else {
                    completion(.error(reason: error?.localizedDescription, code: 0))
                    return
            }
            #if DEBUG
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    debugPrint("\(rest.description) answer: \(json)")
                }
            #endif
            if httpResponse.statusCode == rest.statusCode {
                completion(.success(data: data, code: httpResponse.statusCode))
            } else {
                let responseError = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(.error(reason: responseError?.error.reason, code: httpResponse.statusCode))
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

