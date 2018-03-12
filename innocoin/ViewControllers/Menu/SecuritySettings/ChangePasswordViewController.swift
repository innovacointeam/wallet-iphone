//
//  ChangePasswordViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 09.03.2018.
//  email: yuri.drigin@icloud.com  skype: yuri.drigin
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    var type: ChangePasswordControllerType = .password
    
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var retypePasswordField: PasswordTextField!
    @IBOutlet weak var newPasswordField: PasswordTextField!
    @IBOutlet weak var currentPasswordField: PasswordTextField!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var retypePasswordLabel: UILabel!
    @IBOutlet weak var currenPasswordLabel: UILabel!
    
    var pincodeContainer: UIView!
    var pincodeController: PincodeViewController!
    var activeTextField: UITextField!
    
    var blur: UIView?
    var active: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsContainer.applyGradient(colours: [.startButtonGradient, .endButtonGradient])
        buttonsContainer.layer.cornerRadius = 5.0
        buttonsContainer.clipsToBounds = true
        
        currentPasswordField.passwordShow = false
        newPasswordField.passwordShow = false
        retypePasswordField.passwordShow = true
        
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        retypePasswordField.delegate = self
        
        hideKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = type.title
        newPasswordLabel.text = type.newPasswordLabel
        newPasswordField.placeholder = type.newPasswordPlaceholder
        
        retypePasswordField.placeholder = type.retypePasswordPlaceholder
        retypePasswordLabel.text = type.retypePasswordLabel
        
        currenPasswordLabel.text = type.currentPasswordLabel
        currentPasswordField.placeholder = type.currentPasswordPlaceholder
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        guard let navVC = navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        navVC.popViewController(animated: true)
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        guard let value1 = currentPasswordField.text,
            let value2 = newPasswordField.text,
            let value3 = retypePasswordField.text else {
                showAlert("All field must be filled", title: type.title)
                return
        }
        
        navigationController?.isNavigationBarHidden = true
        blur = bluring()
        active = self.showActivityIndicatory(in: view, text: "\(type.title). Please wait...")
        if type == .password {
            RESTController.shared.changePassword(pincode: value1, password: value2, newPassword: value3) { [weak self] response in
                DispatchQueue.main.async {
                    self?.populateREST(response: response)
                }
            }
        }
        if type == .pincode {
            RESTController.shared.changePincode(password: value1, pincode: value2, newPincode: value3) { [weak self] response in
                DispatchQueue.main.async {
                    self?.populateREST(response: response)
                }
            }
        }
    }
    
    private func populateREST(response: ServerResponse) {
        active?.removeFromSuperview()
        blur?.removeFromSuperview()
        navigationController?.isNavigationBarHidden = false
        switch response {
        case .error(let reason, let code):
            showAlert("\(code ?? 0): \(reason ?? "Unknown error")", title: type.title)
        case .success(let data, _):
            if let serverMessage = try? JSONDecoder().decode(MessageResult.self, from: data).result.message {
                showAlert(serverMessage, title: type.title) {
                    RouterViewControllers.shared.pop()
                }
            } else{
                RouterViewControllers.shared.pop()
            }
        }
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var canEdit = true
        switch (type, textField.tag) {
        case (.pincode,2),
             (.pincode,3),
             (.password,1):
            canEdit = false
            activeTextField = textField
        default:
            break
        }
        if !canEdit {
            pincodeContainer = createPincodeContainer()
            pincodeController = appearPincodeController()
        }
        return canEdit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1 {
            newPasswordField.becomeFirstResponder()
        }
        if textField.tag == 2 {
            retypePasswordField.becomeFirstResponder()
        }
        return true
    }
    
}
