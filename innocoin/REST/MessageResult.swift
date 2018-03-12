//
//  MessageResult.swift
//  innocoin
//
//  Created by Yuri Drigin on 12.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct MessageAnswer: Codable {
    var message: String
}

struct MessageResult: Codable {
    var result: MessageAnswer
}
