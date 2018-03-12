//
//  QuestionsList.swift
//  innocoin
//
//  Created by Yuri Drigin on 27.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct QuestionList: Codable {
    
    var questions: [String]
    
    enum CodingKeys: String, CodingKey {
        case questions = "security_questions"
    }
}


struct QuestionListResponse: Codable {
    
    var result: QuestionList
    
}
