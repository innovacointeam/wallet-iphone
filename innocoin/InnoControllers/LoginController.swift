//
//  LoginController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

class LoginController {
    
    static let shared = LoginController()
    
    var questions = [String]()
    
    private init() { }
    
    func getQuestions() {
        RESTController.shared.getQuestions() { (response: ServerResponse)in
            switch response {
            case .success(let data, _):
                do {
                    let questionsList = try JSONDecoder().decode(QuestionListResponse.self, from: data)
                    self.questions = questionsList.result.questions
                    debugPrint("QuestionsList count \(questionsList.result.questions.count)")
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
    
    func singin(with email: String, password: String, completion: @escaping (Bool, String?)->()) {
        RESTController.shared.signin(email: email, password: password) { response in
            switch response {
            case .success(let data, _):
                let answer = try? JSONDecoder().decode(SignInResult.self, from: data)
                UserController.shared.token = answer?.result.token
                UserController.shared.profile = answer?.result.user
                completion(true, nil)
            case .error(let reason, let code):
                completion(false, "\(code ?? 0): \(reason ?? "Unknown reasons")")
            }
        }
    }

    func singup(user: SignUpUser, completion: @escaping (Bool, String?)->()) {
        RESTController.shared.signup(user: user) { response in
            switch response {
            case .success(let data, _):
                UserController.shared.profile = try? JSONDecoder().decode(SignUpResult.self, from: data).result
                completion(true, nil)
            case .error(let reason, let code):
                completion(false, "\(code ?? 0): \(reason ?? "Unknown reasons")")
            }
        }
    }
}
