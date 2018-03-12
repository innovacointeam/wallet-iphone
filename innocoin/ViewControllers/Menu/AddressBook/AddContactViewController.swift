//
//  AddContactViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 06.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var innovaAddressField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        createButton.applyTheme()
        
        fullNameField.delegate = self
        innovaAddressField.delegate = self
        fullNameField.textColor = UIColor.textColor
        innovaAddressField.textColor = UIColor.textColor
    }
  
    @IBAction func createContactTapped(_ sender: Any) {
        guard let name = fullNameField.text, !name.isEmpty else {
                showAlert("Contact name must be not empty", title: "Add contact")
                return
        }
        
        #if DEBUG
            guard let wallet = innovaAddressField.text, !wallet.isEmpty else {
                showAlert("Innova wallet must be correct lenght", title: "Add contact")
                return
            }
        #else
            guard let wallet = innovaAddressField.text, wallet.count == 45 else {
                showAlert("Innova wallet must be correct lenght", title: "Add contact")
                return
            }
        #endif

        
        DataManager.shared.addContact(name, innovaAddress: wallet) { result, reason in
            if !result {
                self.showAlert(reason!, title: "Add Contact")
            } else {
                RouterViewControllers.shared.pop()
            }
        }
    }
    
    
    @IBAction func qrCodeTapped(_ sender: Any) {
        let qrController = storyboard!.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        qrController.delegate = self
        present(qrController, animated: true, completion: nil)
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // set next edit field if first
        if textField.tag == 1 {
            innovaAddressField.becomeFirstResponder()
        }
        return true
    }
    
}


extension AddContactViewController: QRScannerViewControllerDelegate {
    
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
