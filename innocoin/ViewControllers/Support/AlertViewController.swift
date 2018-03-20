//
//  AlertViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 01.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate {
    
    func didCancel()
    func didAction(_ name: String)
    
}

class AlertViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var blur: UIView!
    
    var delegate: AlertViewControllerDelegate?
    var text: String?
    var action: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowOpacity = 0.6
        
        titleLabel.textColor = UIColor.textColor
        message.textColor = UIColor.textColor
        
        buttonStack.layer.cornerRadius = 10
        buttonStack.layer.borderWidth = 1
        buttonStack.clipsToBounds = true
        buttonStack.layer.borderColor = UIColor.buttonBorderColor.cgColor
        
        // Update view
        titleLabel.text = title
        message.text = text
        titleLabel.isHidden = title == nil
        message.isHidden = text == nil
        actionButton.setTitle(action, for: .normal)
        actionButton.setTitleColor(UIColor.settingsTintColor, for: .normal)
        cancelButton.setTitleColor(UIColor.settingsTintColor, for: .normal)
        cancelButton.makeCornersRounded([.topLeft, .bottomLeft], radius: 5, witdh: 1, color: UIColor.settingsTintColor)
        actionButton.makeCornersRounded([.topRight, .bottomRight], radius: 5, witdh: 1, color: UIColor.settingsTintColor)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        let action = actionButton.titleLabel?.text ?? "OK"
        delegate?.didAction(action)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.didCancel()
        dismiss(animated: true, completion: nil)
    }

}

extension AlertViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
