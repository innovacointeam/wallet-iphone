//
//  ReceiveViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ReceiveViewController: UIViewController {

    @IBOutlet weak var requestPaymentButton: UIButton!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextField!
    @IBOutlet weak var innovacoinField: UITextField!
    @IBOutlet weak var usdField: UITextField!
    @IBOutlet weak var innovaStack: UIStackView!
    @IBOutlet weak var usdStack: UIStackView!
    
    private var innovaField = InnovaTextField()
    private var usdTextField = USDTextField()
    private var innovaCoin = InnovaCoin()
    private var recepient: String!
    private var origin: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPaymentButton.applyTheme()
        
        hideKeyboard()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(copyQRCode(_:)))
        longTap.minimumPressDuration = 2
        qrCode.isUserInteractionEnabled = true
        qrCode.addGestureRecognizer(longTap)
        walletLabel.text = UserController.shared.account?.address ?? UserController.shared.walletID
        
        qrCode.image = UserController.shared.account?.address.generateQRCode(withSize: qrCode.frame.size.width)
        
        if let placeholder = commentLabel.placeholder {
            commentLabel.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        }
        setupTextFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        origin = view.frame.origin.y
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        var frame = commentLabel.convert(commentLabel.frame, to: self.view)
        frame.size.height += commentLabel.frame.size.height + 44
        let intersection = keyboardFrame.intersection(frame)
        if intersection != CGRect.zero {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.view.frame.origin.y -= intersection.height
            }
        }
    }
    
    @objc private func keyboardDidHide(_ notfication: Notification) {
        guard self.view.frame.origin.y != origin else {
            return
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.frame.origin.y = self?.origin ?? 0
        }
    }
    
    private func setupTextFields() {
        commentLabel.delegate = self
        innovacoinField.removeFromSuperview()
        innovaStack.insertArrangedSubview(innovaField, at: 1)
        innovaField.tag = 1
        innovaField.delegate = self
        innovaField.amountDelegate = self
        
        usdField.removeFromSuperview()
        usdStack.insertArrangedSubview(usdTextField, at: 1)
        usdTextField.tag = 2
        usdTextField.delegate = self
        usdTextField.amountDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if qrCode.image == nil {
            qrCode.image = UserController.shared.account?.address.generateQRCode(withSize: qrCode.frame.size.width)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        guard let amount = innovaField.amount, amount.amount > 0 else {
            showAlert("Requesting amount must be over zero", title: "Payment Request")
            return
        }
        guard let address = UserController.shared.account?.address else {
            showAlert("Something going wrong. Empty your innova address", title: "Payment Request")
            return
        }
        recepient = address
        let message = String(format: InnovaConstanst.requestPaymentMessageTemplate,
                             commentLabel.text ?? "",
                             innovaField.amount.string,
                             recepient)

        var items: [Any] = [message]
        if let image = qrCode.image {
            items.insert(image, at: 0)
        }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.setValue("Innovacoin transaction request", forKey: "subject")
        activityVC.excludedActivityTypes = [.assignToContact, .openInIBooks, .saveToCameraRoll]
        present(activityVC, animated: true, completion: nil)
    }
    
    @objc private func copyQRCode(_ gesture: UILongPressGestureRecognizer) {
        UIPasteboard.general.string = "Innova wallet"
        UIPasteboard.general.image = qrCode.image
        
        showAlert("QR code with wallet ID copied", title: "Innova wallet")
    }
}

extension ReceiveViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Request Innova payment"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        let message = String(format: InnovaConstanst.requestPaymentMessageTemplate,
                             commentLabel.text ?? "Innovacoin transaction request",
                             innovaField.amount.string,
                             recepient)
        var items: [Any] = [message]
        if let qr = qrCode.image {
            items.insert(qr, at: 0)
        }
        return message
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "Innovacoin transaction request"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return qrCode.image?.resize(size)
    }
    
}

extension ReceiveViewController: UITextFieldDelegate, CurrencyTextFieldDelegate {
    
    func didChange(_ textField: UITextField) {
        if textField.tag == 1, let innocoin = (textField as? InnovaTextField)?.amount {
            let usd: USDCoin = MarketPriceController.shared.convert(from: innocoin)
            usdTextField.text = usd.string
        }
        if textField.tag == 2, let usd = (textField as? USDTextField)?.amount {
            let innova: InnovaCoin = MarketPriceController.shared.convert(from: usd)
            innovaField.text = innova.string
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
