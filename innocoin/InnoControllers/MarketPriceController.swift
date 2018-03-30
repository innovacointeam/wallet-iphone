//
//  MarketPriceController.swift
//  innocoin
//
//  Created by Yuri Drigin on 18.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

enum CurrencyTrend {
    
    case up
    case down
    case same
    
    init<T:Comparable>(new: T, old: T) {
        switch (new, old) {
        case let (a,b) where a > b:
            self = .up
        case let (a,b) where a < b:
            self = .down
        default:
            self = .same
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .up:
            return #imageLiteral(resourceName: "RiseArrow")
        case .down:
            return #imageLiteral(resourceName: "downArrow")
        case .same:
            return nil
        }
    }
}

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
            if (oldValue != nil) && oldValue.timestamp < prices.timestamp {
                btcTrend = CurrencyTrend(new: prices.innToBtc, old: oldValue.innToBtc)
                usdTrend = CurrencyTrend(new: prices.innToUsd, old: oldValue.innToUsd)
            }
        }
    }
    
    var INNToUSD: Double {
        return prices?.innToUsd ?? 0
    }
    
    var INNtoBTC: Double {
        return prices?.innToBtc ?? 0
    }
    
    var BTCtoUSD: Double {
        return prices?.btcToUsd ?? 0
    }
    
    var btcTrend: CurrencyTrend = .same
    var usdTrend: CurrencyTrend = .same
    
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
