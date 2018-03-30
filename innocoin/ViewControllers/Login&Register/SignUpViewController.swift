//
//  SignUpViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var sigUpButton: UIButton!
    @IBOutlet weak var emailField: EmailTextField!
    @IBOutlet weak var passwordField: EmailTextField!
    @IBOutlet weak var transactionPasswordField: EmailTextField!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var tempQuestionView: UIView!
    @IBOutlet weak var termsLabel: UILabel!
    
    private var oldConstrait: CGFloat = 0
    private var questionFrame: CGRect = CGRect.zero

    var pincodeContainer: UIView!
    var pincodeController: PincodeViewController!
    var questionsView: UIView!
    var questionController: QuestionsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundViewController

        hideKeyboard()
        
        if let text = answerField.placeholder {
            answerField.attributedPlaceholder = NSAttributedString(string: text,
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        
        emailField.delegate = self
        passwordField.delegate = self
        transactionPasswordField.delegate = self
        answerField.delegate = self
        
        if LoginController.shared.questions.count > 0 {
            questionButton.setTitle(LoginController.shared.questions[0], for: .normal)
            questionButton.tag = 0
        }

        // Add observer to keyboard show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp else {
            fatalError("Cannot get Innocoin App class")
        }
        
        // Set button disable to avoid second atempt
        sigUpButton.isEnabled = false
        
        // And enable it after
        defer {
            sigUpButton.isEnabled = true
        }
        
        // Validate all inputs to check signup ability
        guard let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let pincode = transactionPasswordField.text, !pincode.isEmpty,
            let question = questionButton.titleLabel?.text,
            let answer = answerField.text, !answer.isEmpty else {
              showAlert("All fields must be filled correctly before singup")
                return
        }

        let user = SignUpUser(email: email,
                              password: password,
                              pincode: pincode,
                              securityQuestion: SecurityQuestion(question: question, answer: answer))
        
        
        // If not validate - send it back
        if let reason = user.validate() {
            showAlert(reason)
            return
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let blur = bluring()
        let activity = showActivityIndicatory(in: view, text: "Sign Up. Please wait...")
        
        LoginController.shared.singup(user: user) { [weak self] result, reason in
            DispatchQueue.main.async {
                if result {
                    // To after sigup - send back to login becouse need verify account
                    self?.showAlert("Account created succefull. Please check email to activate", title: "Signup") {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    activity.removeFromSuperview()
                    blur.removeFromSuperview()
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                    self?.showAlert(reason!)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Try reload questions if not yet
        LoginController.shared.reloadQuestionsIfNeed()
        oldConstrait = view.frame.origin.y
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sigUpButton.applyTheme()
    }
    
    //MARK: - Observe getKayboardHeight
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        // Hide question table
        hideQuestionstableIfNeed()
        
        if answerField.isFirstResponder {
            oldConstrait = view.frame.origin.y
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = self.oldConstrait - keyboardHeight
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard view.frame.origin.y != oldConstrait else {
            return
        }
        // Scroll view back
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.oldConstrait
        }
    }
    
    // MARK: Select question
    @IBAction func questionTapped(_ sender: Any) {
        // Skip if already show questions
        appearQuestionController()
    }
    
    override func dismissKeyboard(_ gesture: UIGestureRecognizer) {
        super.dismissKeyboard(gesture)
        
        hideQuestionstableIfNeed()
        
        guard let text = termsLabel.text else {
            return
        }
        let linkRange = (text as NSString).range(of: "Innova Wallet Terms of Service")
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: linkRange) {
            if UIApplication.shared.canOpenURL(InnovaConstanst.innovaTermsAndServiceLink) {
                UIApplication.shared.open(InnovaConstanst.innovaTermsAndServiceLink)
            }
        }
    }
    

}


extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 3 {
            // show pincode input controller
            pincodeContainer = createPincodeContainer()
            pincodeController = appearPincodeController()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
