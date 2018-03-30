//
//  InnovaConstants.swift
//  innocoin
//
//  Created by Yuri Drigin on 16.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

struct InnovaConstanst {
    static let defaultTimeoutInterval: TimeInterval = 60
    static let confirmationCountForConfirmTransaction = 10
    static let maxConfirmationsCountToShow: Int64 = 20
    
    static let innovaURLScheme = "http"
    static let innovaURLHost = "159.89.109.174"
    static let innovaAPIPath = "/api/v1.0"
    static let innoHost = URL(string: "http://159.89.109.174/api/v1.0")!
    static let innovaTermsAndServiceLink = URL(string: "https://innovacoin.info/terms-of-service")!
    static let innovePrivacyPolicyLink = URL(string: "https://innovacoin.info/privacy-policy")!
    static let supportEmail = "support@innovacoin.info"
    
    static let decimalSeparator = Locale.current.decimalSeparator ?? "."
    /// Innovacoin transaction request: {description} Amount: {amount} INN Address: {address}
    /// qr code add independently
    static let requestPaymentMessageTemplate =
    """
    Innovacoin transaction request: %@
    Amount: %@ INN
    Address: %@
    """
}
