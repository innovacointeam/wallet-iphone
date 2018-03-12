//
//  UIButton+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

extension UIButton {
    
    func applyTheme() {
        self.applyGradient(colours: [.startButtonGradient, .endButtonGradient])
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
    
    func makeCornersRounded(_ corners: UIRectCorner, radius: CGFloat, witdh: CGFloat, color: UIColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = nil
        borderLayer.borderWidth = witdh
        let borderPath = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius, height: radius))
        borderLayer.path = borderPath.cgPath
        layer.insertSublayer(borderLayer, at: 0)
    }
}
