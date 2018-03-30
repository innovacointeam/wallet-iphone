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
    @IBOutlet weak var innFakeField: UITextField!
    @IBOutlet weak var btcFakeField: UITextField!
    @IBOutlet weak var innFakeUSDField: UITextField!
    @IBOutlet weak var usdFakeField: UITextField!
    @IBOutlet weak var priceContainer: UIView!
    @IBOutlet weak var calculatorContainer: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var btcTrendImage: UIImageView!
    @IBOutlet weak var usdTrendImage: UIImageView!
    @IBOutlet weak var inntoBtcStack: UIStackView!
    @IBOutlet weak var btcToInnStack: UIStackView!
    @IBOutlet weak var usdToInnStack: UIStackView!
    @IBOutlet weak var innToUSDStack: UIStackView!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    private var CalculatorYCenterAnchor: NSLayoutConstraint!
    
    private var price: InnovaPrice! {
        didSet {
            enableInput()
            guard price != nil else {
                return
            }
            populatePrice()
        }
    }
    
    private let innToBtcField = InnovaTextField()
    private let btcToInnField = BitcoinTextField()
    private let innToUSDField = InnovaTextField()
    private let usdToInnField = USDTextField()

    private var originY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        
        // Clear all fields
        populatePrice()
        prepareCoinFields()
        
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
        calculatorContainer.translatesAutoresizingMaskIntoConstraints = false
        CalculatorYCenterAnchor = centerY
        
        price = MarketPriceController.shared.last()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)),
                                               name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Innova Price"

        MarketPriceController.shared.fetchNew() { [weak self] newPrices in
            self?.price = newPrices
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originY = CalculatorYCenterAnchor.constant
    }
    
    private func prepareCoinFields() {
        innFakeField.removeFromSuperview()
        btcFakeField.removeFromSuperview()
        innFakeUSDField.removeFromSuperview()
        usdFakeField.removeFromSuperview()
        
        createCoinField(innToBtcField, in: inntoBtcStack, tag: 1)
        innToBtcField.amountDelegate = self
        
        createCoinField(btcToInnField, in: btcToInnStack, tag: 2)
        btcToInnField.amountDelegate = self

        createCoinField(innToUSDField, in: innToUSDStack, tag: 3)
        innToUSDField.amountDelegate = self
        
        createCoinField(usdToInnField, in: usdToInnStack, tag: 4)
        usdToInnField.amountDelegate = self
    }
    
    private func createCoinField(_ field: UITextField, in stack: UIStackView, tag: Int) {
        field.tag = tag
        field.delegate = self
        stack.addArrangedSubview(field)
        field.borderStyle = .roundedRect
        field.adjustsFontSizeToFitWidth = true
        field.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func populatePrice() {
        guard let price = price else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.timestampLabel.text = price.timestamp.description
            self?.priceBTCLabel.text = "BTC \(InnovaCoin(price.innToBtc).string)"
            self?.priceUSDLabel.text = "USD \(USDCoin(price.innToUsd).string)"
            
            self?.btcTrendImage.image = MarketPriceController.shared.btcTrend.icon
            self?.usdTrendImage.image = MarketPriceController.shared.usdTrend.icon
        }

    }
    
    private func enableInput() {
        let enable  =  price != nil
        DispatchQueue.main.async { [weak self] in
            self?.innToBtcField.isEnabled = enable
            self?.btcToInnField.isEnabled = enable
            self?.innToUSDField.isEnabled = enable
            self?.usdToInnField.isEnabled = enable
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
    
    // MARK: - Keyboard observer
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        var frame = calculatorContainer.frame
        frame.size.height += 80
        let intersection = frame.intersection(keyboardFrame)
        if intersection != CGRect.zero {
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.CalculatorYCenterAnchor.isActive = false
                self?.CalculatorYCenterAnchor.constant -= intersection.height
                self?.CalculatorYCenterAnchor.isActive = true
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardDidHide(_ notfication: Notification) {
        guard CalculatorYCenterAnchor.constant != originY else {
            return
        }
        let y  = originY
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.CalculatorYCenterAnchor.isActive = false
            self?.CalculatorYCenterAnchor.constant = y
            self?.CalculatorYCenterAnchor.isActive = true
            self?.view.layoutIfNeeded()
        })
    }
    
}

extension OverviewViewController: CurrencyTextFieldDelegate {
    
    func didChange(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if let innova = (textField as? InnovaTextField)?.amount {
                let btc: Bitcoin = MarketPriceController.shared.convert(from: innova)
                btcToInnField.text = btc.string
            }
        case 2:
            if let btc = (textField as? BitcoinTextField)?.amount {
                let innova: InnovaCoin = MarketPriceController.shared.convert(from: btc)
                innToBtcField.text = innova.string
            }
        case 3:
            if let innova = (textField as? InnovaTextField)?.amount {
                let usd: USDCoin = MarketPriceController.shared.convert(from: innova)
                usdToInnField.text = usd.string
            }
        case 4:
            if let usd = (textField as? USDTextField)?.amount {
                let innova: InnovaCoin = MarketPriceController.shared.convert(from: usd)
                innToUSDField.text = innova.string
            }
        default:
            break
        }
    }
}


extension OverviewViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
