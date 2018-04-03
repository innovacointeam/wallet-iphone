//
//  AddContactViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 06.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var innovaAddressField: UITextField!
    
    var type: EditContactViewControllerType = .newContact
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        
        fullNameField.delegate = self
        innovaAddressField.delegate = self
        fullNameField.textColor = UIColor.textColor
        innovaAddressField.textColor = UIColor.textColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createButton.setTitle(type.buttonTitle, for: .normal)
        navigationItem.title = type.title
        
        if type == .editContact {
            fullNameField.text  = contact?.fullName
            innovaAddressField.text = contact?.wallet
        }
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createButton.applyTheme()
    }
    
    @IBAction func createContactTapped(_ sender: Any) {
        guard let name = fullNameField.text, !name.isEmpty else {
                showAlert("Contact name must be not empty", title: "Add contact")
                return
        }
        
        #if DEBUG
            guard let wallet = innovaAddressField.text, wallet.count >= 25 else {
                showAlert("Innova address has a wrong length", title: "Add contact")
                return
            }
        #else
            guard let wallet = innovaAddressField.text, wallet.count <= 35 else {
                showAlert("Innova address has a wrong length", title: "Add contact")
                return
            }
        #endif

        switch type {
        case .newContact:
            DataManager.shared.addContact(name, innovaAddress: wallet) { [weak self] result, reason in
                if !result {
                    self?.showAlert(reason!, title: self?.type.title ?? "Error")
                } else {
                    RouterViewControllers.shared.pop()
                }
            }
        case .editContact:
            contact?.fullName = name
            contact?.wallet = wallet
            DataManager.shared.save()
            RouterViewControllers.shared.pop()
        }

    }
    
    
    @IBAction func qrCodeTapped(_ sender: Any) {
        let qrController = storyboard!.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        qrController.delegate = self
        present(qrController, animated: true, completion: nil)
    }
}

extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // set next edit field if first
        if textField.tag == 1 {
            innovaAddressField.becomeFirstResponder()
        }
        return true
    }
    
}


extension EditContactViewController: QRScannerViewControllerDelegate {
    
    func didFail(reason: String) {
        showAlert(reason, title: "QRCode scanning")
    }
    
    func didFinish(code: String?) {
        guard let code = code else {
            return
        }
        innovaAddressField.text = code
    }
    
}
