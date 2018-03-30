//
//  UIColor+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 21.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Initialize color from sRGB value
    ///
    /// - Parameters:
    ///   - sRed: Red Value
    ///   - green: Green Value
    ///   - blue: Blue Value
    ///   - alpha: Alpha color
    convenience init(sRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let sp = CGColorSpace(name: CGColorSpace.sRGB)!
        let comp: [CGFloat] = [sRed, green, blue, alpha]
        let color = CGColor(colorSpace: sp, components: comp)!
        self.init(cgColor: color)
    }
    
    static let startButtonGradient = UIColor(sRed: 249 / 255, green: 158 / 255, blue: 125 / 255, alpha: 1.0)
    static let endButtonGradient = UIColor(sRed: 239 / 255, green: 50 / 255, blue: 91 / 255, alpha: 1.0)
    static let backgroundStatusBar = UIColor(sRed: 0, green: 6 / 255, blue: 98 / 255, alpha: 1.0)
    static let backgroundViewController = UIColor(sRed: 15 / 255, green: 21 / 255, blue: 119 / 255, alpha: 1.0)
    static let placeholderTextColor = UIColor(sRed: 137 / 255, green: 143 / 255, blue: 188 / 255, alpha: 1.0)
    static let underlineTextField = UIColor(sRed: 53 / 255, green: 57 / 255, blue: 120 / 255, alpha: 1.0)
    static let errorMessage = UIColor(sRed: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)

    static let settingsTableSectionHeader = UIColor(sRed: 55 / 255, green: 181 / 255, blue: 241 / 255, alpha: 1.0)
    static let settingsTintColor = UIColor(sRed: 0, green: 6 / 255, blue: 98 / 255, alpha: 1.0)
    static let settingsAccessuaryTintColor = UIColor(sRed: 125 / 255, green: 131 / 255, blue: 181 / 255, alpha: 1.0)
    static let textColor = UIColor(sRed: 0, green: 6 / 255, blue: 98 / 255, alpha: 1.0)
    static let buttonBorderColor = UIColor(sRed: 0, green: 6 / 255, blue: 98 / 255, alpha: 1.0)
    
    static let viewControllerLigthBackground = UIColor(sRed: 245 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1.0)
    static let redInnova = UIColor(sRed: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1.0)
    static let greenInnova = UIColor(sRed: 77 / 255, green: 216 / 255, blue: 101 / 255, alpha: 1.0)
    static let darkYellowInnova = UIColor(sRed: 249/255, green: 192/255, blue: 105/255, alpha: 1.0)
    static let acceptedTransactionColor = UIColor(sRed: 254 / 255, green: 189 / 255, blue: 140 / 255, alpha: 1.0)
}
