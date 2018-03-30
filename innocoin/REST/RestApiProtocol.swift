//
//  RestApiProtocol.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation


typealias Parameters = [String:Any]

protocol RestAPIProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    var method: String { get }
    var path: String { get }
    var param: Parameters { get }
    var queryItems: [URLQueryItem]? { get }
}


extension RestAPIProtocol {
    
    var url: URL {
        var compomnets = URLComponents()
        compomnets.scheme = InnovaConstanst.innovaURLScheme
        compomnets.host = InnovaConstanst.innovaURLHost
        compomnets.path = InnovaConstanst.innovaAPIPath + self.path
        compomnets.queryItems = self.queryItems
        precondition(compomnets.url != nil, "Failed to coding url for request")
        return compomnets.url!
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.url)
        request.timeoutInterval = InnovaConstanst.defaultTimeoutInterval
        if let token = UserController.shared.token {
            let bearer = "Bearer \(token)"
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = self.method
        if param.count > 0 {
            request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        }
        return request
    }
    
    var debugDescription: String {
        let text = """
            URL for request: \(self.url.absoluteString)
            Method: \(self.method)
            With param: \(param)")
        """
        return text
    }
}
