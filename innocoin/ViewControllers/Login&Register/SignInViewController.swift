//
//  SignInViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var passwordField: PasswordTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundViewController
        hideKeyboard()

        
        emailTextField.delegate = self
        passwordField.delegate = self
        termsLabel.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Sign In"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.applyTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = ""
    }
    
    override func dismissKeyboard(_ recognizer: UIGestureRecognizer) {
        super.dismissKeyboard(recognizer)
        
        guard let text = termsLabel.text else {
            return
        }
        let linkRange = (text as NSString).range(of: "Innova Wallet Terms of Service")
        if recognizer.didTapAttributedTextInLabel(label: termsLabel, inRange: linkRange) {
            if UIApplication.shared.canOpenURL(InnovaConstanst.innovaTermsAndServiceLink) {
                UIApplication.shared.open(InnovaConstanst.innovaTermsAndServiceLink)
            }
        }
    }
    
    // MARK:  Singin action
    @IBAction func singinTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp else {
            fatalError("Can't get InnocoinApp")
        }
        
        view.endEditing(true)
        
        // TODO:  - Check email and password for validate
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
                showAlert("Email and password must be filled before sign in")
                return
        }
        
        if !emailTextField.isValid() {
            showAlert("Invalid email format")
            return
        }
        
        if password.count < 7 {
            showAlert("Password must be at least 7 symbols")
            return
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let blur = bluring()
        let activity = showActivityIndicatory(in: view, text: "Loading. Please wait...")
        
        LoginController.shared.singin(with: email, password: password) { [weak self] result, reason in
            DispatchQueue.main.async {
                activity.removeFromSuperview()
                blur.removeFromSuperview()
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                if result {
                    // check account status
                    if UserController.shared.profile.status == .pending {
                        // Show Verify Token Controller
                        if let verifyVC = self?.storyboard?.instantiateViewController(withIdentifier: "VerifyTokenViewController") {
                            self?.navigationController?.pushViewController(verifyVC, animated: true)
                        }
                    } else {
                        // go to main tabbar
                        app.setRoot(controllerName: "MainTabBarController")
                    }
                } else {
                    self?.showAlert(reason ?? "Unknown error")
                }
            }
        }
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1 {
            passwordField.becomeFirstResponder()
        }
        return true
    }
    
}
