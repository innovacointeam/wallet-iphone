//
//  ResetPasswordViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: EmailTextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var asnwerField: UITextField!
    @IBOutlet weak var questionButton: UIButton!
    
    private var error: String? {
        didSet {
            errorLabel.text = error
            errorLabel.isHidden = error == nil
            emailField.isInputError = error != nil
        }
    }

    private var questionFrame = CGRect.zero
    private lazy var questionTableView: UIView = {
        var frame = CGRect.zero
        frame.origin = questionButton.convert(questionButton.frame.origin, to: view)
        frame.size.width = asnwerField.frame.size.width
        frame.size.height = 200
        questionFrame = frame
        let newView = UIView(frame: frame)
        newView.frame.size.height = 0
        newView.layer.cornerRadius = 10
        newView.clipsToBounds = true
        newView.layer.shadowColor = UIColor.darkGray.cgColor
        newView.layer.shadowRadius = 10
        newView.layer.shadowOpacity = 0.5
        newView.layer.shadowOffset = CGSize(width: 2, height: 2)
        newView.layer.masksToBounds = false
        newView.isHidden = true
        view.addSubview(newView)
        newView.layoutIfNeeded()
        return newView
    }()
    
    private lazy var questionController: QuestionsTableViewController = {
        let controller = storyboard!.instantiateViewController(withIdentifier: "QuestionsTableViewController") as! QuestionsTableViewController
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        
        view.backgroundColor = UIColor.backgroundViewController
        resetButton.applyTheme()
        errorLabel.textColor = UIColor.errorMessage
        popupContainer.isHidden = true
        popupContainer.layer.cornerRadius = 10
        popupContainer.clipsToBounds = true
        
        emailField.delegate = self
        asnwerField.delegate = self
        
        if LoginController.shared.questions.count > 0 {
            questionButton.setTitle(LoginController.shared.questions[0], for: .normal)
            questionButton.tag = 0
        }
        
        if let text = asnwerField.placeholder {
            asnwerField.attributedPlaceholder = NSAttributedString(string: text,
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // Try reload questions if not yet
        LoginController.shared.reloadQuestionsIfNeed()
        
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        error = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = CGRect.zero
        frame.origin = questionButton.convert(questionButton.frame.origin, to: view)
        frame.size.width = asnwerField.frame.size.width
        frame.size.height = 200
        questionFrame = frame
    }
    
    override func dismissKeyboard(_ gesture: UIGestureRecognizer) {
        super.dismissKeyboard(gesture)
        
        hideQuestionstableIfNeed()
    }
    
    // MARK: - User action
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        resetPassword()
    }
    
    @IBAction func questionButtonTapped(_ sender: Any) {
        guard questionTableView.isHidden else {
            return
        }
        
        let frame = questionFrame
        add(chield: self.questionController, in: self.questionTableView)
        questionTableView.isHidden = false
        questionTableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.questionTableView.frame = frame
            self?.questionTableView.layoutIfNeeded()
        }
    }
    
    
    private func resetPassword() {
        guard let email = emailField.text, !email.isEmpty, emailField.isValid() else {
            showAlert("Email must be in correct format", title: "Reset password")
            return
        }
        
        guard let question = questionButton.titleLabel?.text,
            LoginController.shared.questions.contains(question) else {
                showAlert("Must select qestions from list", title: "Reset password")
                return
        }
        
        guard let answer = asnwerField.text, !answer.isEmpty else {
            showAlert("Answer must be inputed", title: "Reset password")
            return
        }
        
        navigationController?.isNavigationBarHidden = true
        let blur = bluring()
        let activity = showActivityIndicatory(in: view, text: "Reset password. Please wait...")
        
        RESTController.shared.resetPassword(email: email, question: question, answer: answer) { [weak self] response in
            blur.removeFromSuperview()
            activity.removeFromSuperview()
            self?.navigationController?.isNavigationBarHidden = false
            
            switch response {
            case .error(let reason, _):
                self?.showAlert("\(reason ?? "unknown")", title: "Reset Error")
            case .success:
                RouterViewControllers.shared.pop()
            }
        }

    }
    
    private func hideQuestionstableIfNeed() {
        if !questionTableView.isHidden {
            var frame = questionTableView.frame
            frame.size.height = 0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.questionTableView.frame  = frame
                },
                           completion: {  _ in
                            self.questionTableView.isHidden = true
                            self.remove(chield: self.questionController)
            })
        }
    }
}

extension ResetPasswordViewController: QuestionTableViewControllerDelegate {
    
    func didSelect(_ question: Int) {
        if question != -1 {
            let securyQuestion = LoginController.shared.questions[question]
            debugPrint("Select question \(securyQuestion)")
            questionButton.setTitle(securyQuestion, for: .normal)
            questionButton.tag = question
            asnwerField.text = nil
        }
        hideQuestionstableIfNeed()
    }
}


extension ResetPasswordViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        error = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
