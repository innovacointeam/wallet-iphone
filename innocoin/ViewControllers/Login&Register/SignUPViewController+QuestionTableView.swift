//
//  SignUpViewcontroller+QuestionTableView.swift
//  innocoin
//
//  Created by Yuri Drigin on 27.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension SignUpViewController: QuestionTableViewControllerDelegate {
    
    func createQuestionView() -> UIView {
        var frame = tempQuestionView.frame
        frame.size.height = 0
        let newView = UIView(frame: frame)
        newView.layer.cornerRadius = 10
        newView.clipsToBounds = true
        newView.layer.shadowColor = UIColor.darkGray.cgColor
        newView.layer.shadowRadius = 10
        newView.layer.shadowOpacity = 0.5
        newView.layer.shadowOffset = CGSize(width: 2, height: 2)
        newView.layer.masksToBounds = false
        view.addSubview(newView)
        newView.backgroundColor = UIColor.clear
        
        newView.layoutIfNeeded()
        return newView
    }
    
    func createQuestionController() -> QuestionsTableViewController {
        guard questionController == nil else {
            return questionController
        }
        let controller = storyboard!.instantiateViewController(withIdentifier: "QuestionsTableViewController") as! QuestionsTableViewController
        controller.delegate = self
        return controller
    }
    
    func appearQuestionController() {
        // if container showing - skip
        guard questionController == nil else {
            return
        }
        questionsView = createQuestionView()
        questionController = createQuestionController()
        add(chield: questionController, in: questionsView)
        
//         animated show
        var frame = questionsView.frame
        frame.size.height  = QuestionsTableViewController.preferedSize.height
        UIView.animate(withDuration: 0.3) {
            self.questionsView.frame = frame
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
    
    func hideQuestionstableIfNeed() {
        guard questionsView != nil else {
            return
        }
        var frame = questionsView.frame
        frame.size.height = 0
        UIView.animate(withDuration: 0.3, animations: {
                self.questionsView.frame  = frame
            }, completion: { _ in
                self.remove(chield: self.questionController)
                self.questionsView.removeFromSuperview()
                self.questionsView = nil
                self.questionController = nil
        })
    }
}
