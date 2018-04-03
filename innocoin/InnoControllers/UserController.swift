//
//  UserController.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

class UserController {
    
    static let shared = UserController()
    
    var profile: UserProfile!
    var token: String! {
        didSet {
            guard token != nil else {
                return
            }
            parceToken()
            // Request wallet directly after get token
            RESTController.shared.wallet()
        }
    }
    private var tokenSign: TokenData? {
        didSet {
            guard let validData = tokenSign?.exp_time.date else {
                return
            }
            debugPrint("Token expired: \(validData)")
            if timer?.isValid ?? false {
                timer?.invalidate()
                timer = nil
            }
            
            let period = validData.timeIntervalSince1970 - Date().timeIntervalSince1970 - 180
            debugPrint("Set timer for: \(period)")
            timer = Timer.scheduledTimer(withTimeInterval: period, repeats: false, block: { _ in
                LoginController.shared.tokenExpired()
            })
        }
    }
    private var timer: Timer?
    
    var isTokenValid: Bool {
        guard let sign = tokenSign else {
            return false
        }
        return sign.exp_time.date > Date()
    }
    
    var wallet: InnovaWallet!
    var pending = [PendingTransaction]()
    
    var walletID: String? {
        return wallet?.id ?? profile?.wallet
    }
    
    var account: InnovaWalletAddress? {
        return wallet?.addresses.first
    }
    
    var status: AccountStatus {
        return profile.status
    }
    
    var email: String {
        return profile.email
    }
    
    
    private init() { }
    
    deinit {
        
    }
    
    func logout() {
        profile = nil
        token = nil
    }
    
    private func parceToken() {
        guard let token = token else {
            return
        }
        let  tokenArray = token.split(separator: ".")
        // Fix base 64 string to 4 bytes
        var encodedJSON = String(tokenArray[1])
        let reminder = encodedJSON.count % 4
        if reminder > 0 {
            encodedJSON = encodedJSON.padding(toLength: encodedJSON.count + (4 - reminder), withPad: "=", startingAt: 0)
        }
        do {
            if let tokenData = Data(base64Encoded: encodedJSON) {
                let json = try JSONDecoder().decode(TokenData.self, from: tokenData)
                tokenSign = json
            }
        } catch let error as DecodingError {
            debugPrint(error)
        } catch let error as NSError {
            debugPrint(error.userInfo)
        }
    }
    
    /// Check if user can send coins
    ///
    /// - Parameter innova: InnovaCoin Struct with amount to send
    /// - Returns: Yes or No
    func canSend(_ innova: InnovaCoin) -> Bool {
        return (innova.amount <= wallet.balance.amount)
    }
}
