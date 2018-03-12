//
//  NumberButton.swift
//  innocoin
//
//  Created by Yuri Drigin on 27.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

@IBDesignable
class NumberButton: UIButton {

    @IBInspectable public var borderWidth: CGFloat = 1.0
    @IBInspectable public var borderColor: UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
