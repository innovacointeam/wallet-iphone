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
            populateTransaction()
        }
    }
    
    var pending: PendingTransaction! {
        didSet {
            guard pending != nil else {
                return
            }
            populatePending()
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
        statusLabel.text = transaction.type.description
        let color = transaction.status == .confirmed ? transaction.type.color : transaction.type.color.withAlphaComponent(0.5)
        statusLabel.textColor = color
        amountLabel.backgroundColor = color
        amountLabel.text = transaction.amountCoins.humanDescription
    }
    
    func populatePending() {
        dateLabel.text = pending.created.humanReadable
        statusLabel.text = pending.description
        statusLabel.textColor = UIColor.lightGray
        amountLabel.backgroundColor = UIColor.lightGray
        amountLabel.text = pending.amount.humanDescription
    }
    
}
