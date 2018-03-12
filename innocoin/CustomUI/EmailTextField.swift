//
//  EmailTextField.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

@IBDesignable
class EmailTextField: UITextField {

    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineColor: UIColor = UIColor.underlineTextField
    
    var isInputError = false 

    override func awakeFromNib() {
        super.awakeFromNib()
        keyboardType = .emailAddress
    }
    
    override func draw(_ rect: CGRect) {
        let color = isInputError ? UIColor.errorMessage : lineColor
        drawBottomLine(in: rect, width: lineWidth, color: color)
        
        if let text = placeholder {
            attributedPlaceholder = NSAttributedString(string: text,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        }
    }

    func isValid() -> Bool {
        guard let testStr = self.text else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
