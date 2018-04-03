//
//  SendViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var receiverField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var amountStatusLabel: UILabel!
    @IBOutlet weak var innovaTempField: UITextField!
    @IBOutlet weak var usdTempField: UITextField!
    @IBOutlet weak var innovaStack: UIStackView!
    @IBOutlet weak var usdStack: UIStackView!
    @IBOutlet weak var myWalletLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    
    private var innovaTextField = InnovaTextField()
    private var usdTextField = USDTextField()
    
    private var activeTextField: UITextField?
    private var origin: CGFloat!
    
    private var amount: InnovaCoin!
    private var recepientAddress: String!
    
    var pincodeContainer: UIView!
    var pincodeController: PincodeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        
        receiverField.setPlaceholder(color: UIColor.placeholderTextColor)
        descriptionField.setPlaceholder(color: UIColor.placeholderTextColor)
        
        amountStatusLabel.text = " "
//        myWalletLabel.text = UserController.shared.account?.address
        
        setupCoinFields()
        registerForKeyboardNotifcation()
        descriptionField.delegate = self
        receiverField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        origin = view.frame.origin.y
        receiverField.insertText(DataManager.shared.selectedAddressToSend)
        DataManager.shared.selectedAddressToSend = ""
    }
    
    private func registerForKeyboardNotifcation() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let active = activeTextField else {
            return
        }
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        var activeFrame = active.convert(active.frame, to: self.view)
        activeFrame.size.height += 44 // Append space
        let intersection = keyboardFrame.intersection(activeFrame)
        if intersection.size != CGSize.zero {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y = -intersection.size.height
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        guard view.frame.origin.y != origin else {
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.frame.origin.y = (self?.origin)!
        }
    }
    
    override func dismissKeyboard(_ recognizer: UIGestureRecognizer) {
        super.dismissKeyboard(recognizer)
        keyboardWillHide()
        
        disapearPincodeController()
    }
    
    // TODO:  Refactoring this.
    // Use temp fields becouse can't place subclass of generic class as IBOutlet
    private func setupCoinFields() {
        innovaTempField.removeFromSuperview()
        usdTempField.removeFromSuperview()
        
        innovaStack.insertArrangedSubview(innovaTextField, at: 1)
        usdStack.insertArrangedSubview(usdTextField, at: 1)
        innovaTextField.tag = 1
        innovaTextField.amountDelegate = self
        innovaTextField.delegate = self
        usdTextField.tag = 1
        usdTextField.amountDelegate = self
        usdTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - User actions
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
    
    @IBAction func qrCodeTapped(_ sender: Any) {
        let qrController = storyboard!.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        qrController.delegate = self
        present(qrController, animated: true, completion: nil)
    }
    
    
    @IBAction func feeSwitchChanged(_ sender: Any) {
        
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        // TODO:  - Need refactor. Move preconditions to UserController - Wallet
        guard let innova = innovaTextField.amount,
            (innova != InnovaCoin.zero) && (UserController.shared.canSend(innova)) else {
                showAlert("Wrong amount to send", title: "Send Innova")
                return
        }
        
        guard let recepient = receiverField.text, !recepient.isEmpty else {
            showAlert("Recepient must be specified", title: "Send Innova")
            return
        }
        
        amount = innova
        recepientAddress = recepient
        view.endEditing(true)
        // Ask pincode
        pincodeContainer = createPincodeContainer()
        pincodeController = appearPincodeController()
    }
}

// MARK: -  TextField Delegate
extension SendViewController: UITextFieldDelegate, CurrencyTextFieldDelegate {
    
    func didChange(_ textField: UITextField) {
        if textField.tag == 1, let innocoin = (textField as? InnovaTextField)?.amount {
            let usd: USDCoin = MarketPriceController.shared.convert(from: innocoin)
            usdTextField.text = usd.string
        }
        if textField.tag == 2, let usd = (textField as? USDTextField)?.amount {
            let innova: InnovaCoin = MarketPriceController.shared.convert(from: usd)
            innovaTextField.text = innova.string
        }
        amountStatusLabel.text = UserController.shared.canSend(innovaTextField.amount) ? " " : "Insufficient funds"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if pincodeController != nil {
            remove(chield: pincodeController)
            pincodeContainer.removeFromSuperview()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SendViewController: PincodeViewControllerDelegate {
    
    func didEnter(pin: String?) {
        guard let pincode = pin else {
            return
        }
        pincodeContainer.removeFromSuperview()
        pincodeController = nil
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        let blur = bluring()
        let activity = showActivityIndicatory(in: view, text: "Sending Innova. Please wait...")
        RESTController.shared.send(to: recepientAddress, amount: amount.amount,
                                   pincode: pincode, comment: descriptionField.text) { [weak self] response in
            DispatchQueue.main.async {
                activity.removeFromSuperview()
                blur.removeFromSuperview()
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                switch response {
                case .error(let reason, let title):
                    self?.showAlert("\(reason ?? "Unknown")", title: title ?? "Innova")
                case .success(let data, _):
                    if let request = try? JSONDecoder().decode(PendingTransactionResponse.self, from: data),
                        let pending =  request.request {
                        UserController.shared.pending.insert(pending, at: 0)
                        self?.showAlert("Your transaction request has been accepted", title: "Innova") {
                            self?.innovaApp?.mainTabBar?.setTransactions()
                        }
                    } else {
                        self?.innovaApp?.mainTabBar?.setTransactions()
                    }
                }
            }
        }
    }
    
}

// MARK: -  QRScannerCotroller Delegate
extension SendViewController: QRScannerViewControllerDelegate {
    
    func didFail(reason: String) {
        showAlert(reason, title: "QRCode scanning")
    }
    
    func didFinish(code: String?) {
        guard let code = code else {
            return
        }
        receiverField.text = code
    }
    
}
