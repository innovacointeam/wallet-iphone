//
//  LoginController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

class LoginController {
    
    static let shared = LoginController()
    
    var questions = [String]()
    private var atemptToRenowalToken = false
    
    static let EmailLoginKey = "com.innova.emaillogin.key"
    private var email: String! {
        didSet {
            guard email != nil else {
                return
            }
            UserDefaults.standard.set(email, forKey: LoginController.EmailLoginKey)
            UserDefaults.standard.synchronize()
            if oldValue != nil, oldValue != email {
                DataManager.shared.clear()
            }
        }
    }
    private var password: String!
    
    private init() {
        email = UserDefaults.standard.string(forKey: LoginController.EmailLoginKey)
        
        if let data = DataManager.shared.sequrityQuestion {
            if let list = try? JSONDecoder().decode(QuestionListResponse.self, from: data) {
                questions = list.result.questions
            }
        }
    }
    
    func getQuestions() {
        RESTController.shared.getQuestions() { (response: ServerResponse)in
            switch response {
            case .success(let data, _):
                do {
                    let questionsList = try JSONDecoder().decode(QuestionListResponse.self, from: data)
                    self.questions = questionsList.result.questions
                    DataManager.shared.sequrityQuestion = data
                } catch let error as NSError {
                    debugPrint("Encodable error \(error.localizedFailureReason ?? error.localizedDescription)")
                }
            case .error:
                break
            }
        }
    }
    
    func reloadQuestionsIfNeed() {
        if questions.count == 0 {
            getQuestions()
        }
    }
    
    func tokenExpired() {
        guard !atemptToRenowalToken else {
            atemptToRenowalToken = false
            return
        }
        atemptToRenowalToken = true
        singin(with: email, password: password) { [weak self] result, _ in
            defer {
                self?.atemptToRenowalToken = false
            }
            if !result {
                let app = UIApplication.shared.delegate as? InnocoinApp
                app?.mainTabBar?.showAlert("Session expired. Please relogin", title: "Innova") {
                    app?.setRoot(UIStoryboard.loginViewController, options: .transitionFlipFromLeft)
                }
            }
        }
    }
    
    
    func singin(with email: String, password: String, completion: @escaping (Bool, String?)->()) {
        RESTController.shared.signin(email: email, password: password) { response in
            switch response {
            case .success(let data, _):
                let answer = try? JSONDecoder().decode(SignInResult.self, from: data)
                UserController.shared.token = answer?.result.token
                UserController.shared.profile = answer?.result.user
                self.email = email
                self.password = password
                completion(true, nil)
            case .error(let reason, _):
                completion(false, "\(reason ?? "Unknown reasons")")
//                self.email = nil
//                self.password = nil
            }
        }
    }

    func singup(user: SignUpUser, completion: @escaping (Bool, String?)->()) {
        RESTController.shared.signup(user: user) { response in
            switch response {
            case .success(let data, _):
                UserController.shared.profile = try? JSONDecoder().decode(SignUpResult.self, from: data).result
                completion(true, nil)
            case .error(let reason, _):
                completion(false, "\(reason ?? "Unknown reasons")")
            }
        }
    }
}
