//
//  OverviewViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var priceBTCLabel: UILabel!
    @IBOutlet weak var priceUSDLabel: UILabel!
    @IBOutlet weak var innField: UITextField!
    @IBOutlet weak var btcField: UITextField!
    @IBOutlet weak var innUSDField: UITextField!
    @IBOutlet weak var usdField: UITextField!
    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var calculatorContainer: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    private var price: InnovaPrice! {
        didSet {
            enableInput()
            guard price != nil else {
                return
            }
            populatePrice()
        }
    }
    
    enum inputField: Int {
        case fromInnToBtc = 1
        case fromBtcToInn = 2
        case fromUsdToInn = 3
        case fromInnToUsd = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        innField.delegate = self
        btcField.delegate = self
        usdField.delegate = self
        innUSDField.delegate = self
        
        // Clear all fields
        priceBTCLabel.text = "BTC 0.00000000"
        priceUSDLabel.text = "USD 0.00"
        innField.text = "0.0"
        btcField.text = "0.0"
        innUSDField.text = "0.0"
        usdField.text = "0.0"

        priceContainer.backgroundColor = UIColor.backgroundStatusBar
        view.backgroundColor = UIColor.viewControllerLigthBackground
        calculatorContainer.layer.cornerRadius = 10
        calculatorContainer.layer.borderWidth = 1.0
        calculatorContainer.layer.borderColor = UIColor.settingsAccessuaryTintColor.cgColor
        calculatorContainer.clipsToBounds = true
        calculatorContainer.layer.shadowColor = UIColor.settingsAccessuaryTintColor.cgColor
        calculatorContainer.layer.masksToBounds = false
        calculatorContainer.layer.shadowOffset = CGSize(width: 5, height: 5)
        calculatorContainer.layer.shadowOpacity = 0.7
        
        price = MarketPriceController.shared.last()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Innova Price"

        MarketPriceController.shared.fetchNew() { [weak self] newPrices in
            self?.price = newPrices
        }
    }
    
    private func populatePrice() {
        timestampLabel.text = price.timestamp.description
        priceBTCLabel.text = String(format: "BTC %.8f", price.btcToUsd)
        priceUSDLabel.text = String(format: "USD %.2f", price.innToUsd)
    }
    
    private func enableInput() {
        let enable  =  price != nil
        innField.isEnabled = enable
        btcField.isEnabled = enable
        innUSDField.isEnabled = enable
        usdField.isEnabled = enable
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
    
    @IBAction func usdToInnTapped(_ sender: Any) {
    }
    
    @IBAction func innToBTCTapped(_ sender: Any) {
    }
    
    private func calculate(_ text: String, tag: Int) {
        guard let value = Double(text) else {
            return
        }
        switch tag {
        case inputField.fromInnToBtc.rawValue:
            btcField.text = String(format: "%.8f", arguments: [value * price.innToBtc])
        case inputField.fromBtcToInn.rawValue:
            innField.text = String(format: "%.8f", arguments: [value /  price.innToBtc])
        case inputField.fromUsdToInn.rawValue:
            innUSDField.text = String(format: "%.8f", arguments: [value / price.innToUsd])
        case inputField.fromInnToUsd.rawValue:
            usdField.text = String(format: "%.2f", arguments: [value *  price.innToUsd])
        default:
            break
        }
    }
}


extension OverviewViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let textRange = Range(range, in: text) else {
                return true
        }
        let updatedText = text.replacingCharacters(in: textRange,  with: string)
        calculate(String(updatedText), tag: textField.tag)
        return true
    }
}
