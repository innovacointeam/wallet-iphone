//
//  PasswordTextField.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

@IBDesignable
class PasswordTextField: UITextField {

    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineColor: UIColor = UIColor.lightGray

    @IBInspectable var openIcon: UIImage! = UIImage(named: "open_eye") {
        didSet {
            if passwordShow {
                openButton.setImage(openIcon, for: .normal)
            }
        }
    }
    
    @IBInspectable var closeIcon: UIImage! = UIImage(named: "close_eye") {
        didSet {
            if !passwordShow {
                openButton.setImage(closeIcon, for: .normal)
            }
        }
    }
    
    
    @IBInspectable var passwordShow: Bool = false {
        didSet {
            let icon = passwordShow ? openIcon : closeIcon
            (rightView as? UIButton)?.setImage(icon, for: .normal)
        }
    }
    
    private lazy var openButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.height * 1.3, height: self.frame.height))
        let icon = passwordShow ? openIcon : closeIcon
        button.addTarget(self, action: #selector(showPassword(_:)), for: UIControlEvents.touchUpInside)
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        return button
    }()
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    override func draw(_ rect: CGRect) {
        drawBottomLine(in: rect, width: lineWidth, color: lineColor)
        
        if let text = placeholder {
            attributedPlaceholder = NSAttributedString(string: text,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setButton()
    }
    
    private func setButton() {
        self.rightViewMode = .always
        self.rightView = openButton
        
        if let text = placeholder {
            attributedPlaceholder = NSAttributedString(string: text,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        }
    }
    
    @objc private func showPassword(_ sender: Any) {
        passwordShow = !passwordShow
        isSecureTextEntry = !passwordShow
    }
}
