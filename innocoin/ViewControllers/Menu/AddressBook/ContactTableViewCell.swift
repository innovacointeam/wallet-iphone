//
//  ContactTableViewCell.swift
//  innocoin
//
//  Created by Yuri Drigin on 09.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var innovaAddressLabel: UILabel!
    @IBOutlet weak var avatarLabel: UIImageView!
    
    var contact: Contact! {
        didSet {
            guard contact != nil else {
                return
            }
            populateContact()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDetailIndicatorColor()
    }

    private func setDetailIndicatorColor() {
        for subView in subviews {
            if let button = subView as? UIButton {
                let image = button.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
                button.setImage(image, for: .normal)
                button.tintColor = UIColor.settingsAccessuaryTintColor
                button.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    
    private func populateContact() {
        nameLabel.text = contact.fullName
        innovaAddressLabel.text = contact.wallet
    }
}
