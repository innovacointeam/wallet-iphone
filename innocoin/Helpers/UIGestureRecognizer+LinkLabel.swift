//
//  UIGestureRecognizer+LinkLabel.swift
//  innocoin
//
//  Created by Yuri Drigin on 14.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else {
            return false
        }
        let locationOfTouchInLabel = self.location(in: label)
        let storage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)
        let container = NSTextContainer(size: CGSize(width: label.frame.size.width, height: label.frame.size.height))
        container.lineFragmentPadding = 0
        container.lineBreakMode = label.lineBreakMode
        container.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(container)
        let index = layoutManager.characterIndex(for: locationOfTouchInLabel,
                                                 in: container,
                                                 fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(index, targetRange)
    }
}
