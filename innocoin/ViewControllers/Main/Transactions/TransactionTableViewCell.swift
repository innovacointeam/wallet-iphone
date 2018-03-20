//
//  TransactionTableViewCell.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            guard transaction != nil else {
                return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountLabel.layer.cornerRadius = 5
        amountLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func populateTransaction() {
        dateLabel.text = transaction.timestamp.humanReadable
        statusLabel.text = transaction.typeDescription
        statusLabel.textColor = transaction.typeDescriptionColor
        amountLabel.backgroundColor = transaction.typeDescriptionColor
        amountLabel.text = transaction.amountCoins.debugDescription
    }
    
}
