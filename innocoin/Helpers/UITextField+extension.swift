//
//  UITextField+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(color: UIColor) {
        if let text = placeholder {
            attributedPlaceholder = NSAttributedString(string: text,
                                                       attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func drawBottomLine(in rect: CGRect, width: CGFloat, color: UIColor) {
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = width
        
        color.setStroke()
        path.stroke()
    }
    
    
}
