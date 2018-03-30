//
//  CurrencyTextField.swift
//  innocoin
//
//  Created by Yuri Drigin on 20.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

@objc protocol CurrencyTextFieldDelegate {
    func didChange(_ textField: UITextField)
}

final class InnovaTextField: CurrencyTextField<InnovaCoin> { }
final class USDTextField: CurrencyTextField<USDCoin> { }
final class BitcoinTextField: CurrencyTextField<Bitcoin> { }

class CurrencyTextField<T: CryptoCurrency>: UITextField {

    var amount: T!
    var amountDelegate: CurrencyTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        text = amount.string
        return super.resignFirstResponder()
    }
    
    private func setup() {
        amount = T()
        keyboardType = .decimalPad
        returnKeyType = .done
        text = nil
        textColor = UIColor.textColor
        attributedPlaceholder = NSAttributedString(string: amount.string,
                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        self.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(endedEdit), for: .editingDidEnd)
    }
    
    @objc private func endedEdit() {
        if amount == T.zero {
            text = nil
        }
    }
    
    @objc private func amountChanged() {
        guard let text = self.text else {
            return
        }
        let separator = InnovaConstanst.decimalSeparator
        // First chek if start from separator - append 0 at begin
        if text == separator {
            self.text = "0" + text
        }
        // Second disable more that one separator
        if let first = text.range(of: separator), let last = text.range(of: separator, options: .backwards) {
            let range = Range(NSRange(location: first.upperBound.encodedOffset, length: text.count - first.upperBound.encodedOffset), in: text)!
            if first != last {
                self.text = text.replacingOccurrences(of: separator, with: "", range: range)
            } else {
                // Check for decimal part length
                let decimalPart  = text[range]
                if decimalPart.count > amount.bits {
                    self.text = String(text.dropLast())
                    self.resignFirstResponder()
                }
            }
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        let number = formatter.number(from: text)
        
        if let value = number?.doubleValue {
            amount.amount = value
            amountDelegate?.didChange(self)
        }
    }
}


