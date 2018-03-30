//
//  TransactionDetailsViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 17.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UITableViewController {

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountInnovaLabel: UILabel!
    @IBOutlet weak var myAccountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountUSDLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var confirmationsCountLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    
    var transaction: Transaction!
    var pending: PendingTransaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(copyID(_:)))
        longTap.minimumPressDuration = 1
        idLabel.isUserInteractionEnabled = true
        idLabel.addGestureRecognizer(longTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if pending == nil {
            populateTransaction()
        } else {
            populatePending()
        }
    }
    
    private func populatePending() {
        guard pending != nil else {
            return
        }

        idLabel.text = pending.id
        directionLabel.text = "From"
        amountTitleLabel.textColor = UIColor.lightGray
        amountInnovaLabel.text = pending.amount.humanDescription
        amountInnovaLabel.textColor = UIColor.lightGray
        let usd: USDCoin = MarketPriceController.shared.convert(from: pending.amount)
        amountUSDLabel.text = usd.humanDescription
        myAccountLabel.text = pending.recepient
        dateLabel.text = pending.created.description
        statusLabel.text = pending.status.rawValue
        statusLabel.textColor = UIColor.lightGray
        confirmationsCountLabel.isHidden = true
        descriptionLabel.text = pending.comment
        
        self.navigationItem.title = pending.description
    }
    
    private func populateTransaction() {
        guard transaction != nil else {
            return
        }

        idLabel.text = transaction.id
        directionLabel.text = transaction.type == .received ? "From" : "To"
        amountInnovaLabel.text = transaction.amountCoins.humanDescription
        amountInnovaLabel.textColor = transaction.mainColor
        amountTitleLabel.textColor = transaction.mainColor
        let usd: USDCoin = MarketPriceController.shared.convert(from: transaction.amountCoins)
        amountUSDLabel.text = usd.humanDescription
        myAccountLabel.text = transaction.address
        dateLabel.text = transaction.timestamp.description
        statusLabel.text = transaction.status.description
        statusLabel.textColor = transaction.statusColor
        confirmationsCountLabel.textColor = transaction.statusColor
        let count = transaction.confirmations > InnovaConstanst.maxConfirmationsCountToShow ? InnovaConstanst.maxConfirmationsCountToShow : transaction.confirmations
        confirmationsCountLabel.text = "\(count)/\(InnovaConstanst.maxConfirmationsCountToShow)"

        descriptionLabel.text = transaction.comment
        self.navigationItem.title = transaction.type.description
    }
    
    @objc private func copyID(_ gesture: UILongPressGestureRecognizer) {
        guard let id = transaction.id else {
            return
        }
        UIPasteboard.general.string = id
        showAlert(id, title: "Copy to pasteboard")
    }
}
