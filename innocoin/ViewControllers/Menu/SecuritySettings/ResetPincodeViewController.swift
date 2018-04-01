//
//  ResetPincodeViewController.swift
//  innocoin
//
//  Created by yuri on 10.03.18.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ResetPincodeViewController: UIViewController {

    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var arrowDownButton: UIButton!
    
    private var questionFrame = CGRect.zero
    private lazy var questionTableView: UIView = {
        var frame = CGRect.zero
        frame.origin = questionButton.convert(questionButton.frame.origin, to: view)
        frame.size.width = answerField.frame.size.width
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
    
    override func dismissKeyboard(_ gesture: UIGestureRecognizer) {
        super.dismissKeyboard(gesture)
        hideQuestionstableIfNeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = CGRect.zero
        frame.origin = questionButton.convert(questionButton.frame.origin, to: view)
        frame.size.width = answerField.frame.size.width
        frame.size.height = 200
        questionFrame = frame
    }
    
    private lazy var questionController: QuestionsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuestionsTableViewController") as! QuestionsTableViewController
        controller.themeBackgroundColor = UIColor.white
        controller.themeTextColor = UIColor.settingsTintColor
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        
        buttonsContainer.applyGradient(colours: [.startButtonGradient, .endButtonGradient])
        buttonsContainer.layer.cornerRadius = 5.0
        buttonsContainer.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Reset Pincode"
        questionButton.setTitle(LoginController.shared.questions[0], for: .normal)
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
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        guard let question = questionButton.titleLabel?.text,
            LoginController.shared.questions.contains(question) else {
                showAlert("Please select question from list before reset", title: "Reset Pincode")
                return
        }
        
        guard let answer = answerField.text, !answer.isEmpty else {
            showAlert("Sequrity answer must be filled", title: "Reset Pincode")
            return
        }
        
        navigationController?.isNavigationBarHidden = true
        let blur = bluring()
        let alert = showActivityIndicatory(in: view, text: "Reseting pincode. Please wait...")
        
        RESTController.shared.resetPincode(question: question, answer: answer) { response in
            DispatchQueue.main.async { [weak self] in
                alert.removeFromSuperview()
                blur.removeFromSuperview()
                self?.navigationController?.isNavigationBarHidden = false
                
                switch response {
                case .error(let reason, let title):
                    self?.showAlert("\(reason ?? "Unknown")", title: title ?? "Reset Pincode")
                case .success(let data, _):
                    if let serverMessage = try? JSONDecoder().decode(MessageResult.self, from: data).result.message {
                        self?.showAlert(serverMessage, title: "Reset Pincode") {
                            RouterViewControllers.shared.pop()
                        }
                    } else{
                        RouterViewControllers.shared.pop()
                    }
                }
            }
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        RouterViewControllers.shared.pop()
    }
    

}

extension ResetPincodeViewController: QuestionTableViewControllerDelegate {
    
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
    
    func didSelect(_ question: Int) {
        if question != -1 {
            let securyQuestion = LoginController.shared.questions[question]
            debugPrint("Select question \(securyQuestion)")
            questionButton.setTitle(securyQuestion, for: .normal)
            questionButton.tag = question
            answerField.text = nil
        }
        hideQuestionstableIfNeed()
    }
}

extension ResetPincodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
