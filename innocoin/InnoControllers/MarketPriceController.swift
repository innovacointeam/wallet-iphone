//
//  MarketPriceController.swift
//  innocoin
//
//  Created by Yuri Drigin on 18.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation

/// Market prices
/// Stored last known market prices
/// In the future can stored history
class MarketPriceController {
	
	static let shared = MarketPriceController()
	
    private let MarketPricesKey = "MarketPricesKey"
    
    private var prices: InnovaPrice! {
        didSet {
            guard prices != nil else {
                return
            }
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(prices) {
                UserDefaults.standard.set(data, forKey: MarketPricesKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var innovaToUSD: Double {
        return prices?.innToUsd ?? 0
    }
    
	private init() {
        if let data = UserDefaults.standard.data(forKey: MarketPricesKey) {
            prices = try? JSONDecoder().decode(InnovaPrice.self, from: data)
        }
    }

    func fetchNew(completion: ((InnovaPrice)->())? = nil) {
        RESTController.shared.price() { response in
            if case let ServerResponse.success(data, _) = response {
                if let newPrices = try? JSONDecoder().decode(InnovaPriceResponse.self, from: data).price {
                    self.prices = newPrices
                    completion?(newPrices)
                }
            }
        }
    }
    
    func update(_ newPrices: InnovaPrice) {
        self.prices = newPrices
    }
    
    func last() -> InnovaPrice? {
        return self.prices
    }
}
