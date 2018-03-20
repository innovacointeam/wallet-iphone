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
    @IBOutlet weak var recepientAccountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountUSDLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var transaction: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateTransaction()
    }
    
    private func populateTransaction() {
        guard transaction != nil else {
            return
        }
        
        directionLabel.text = transaction.typeDescription
        directionLabel.textColor = transaction.typeDescriptionColor
        amountInnovaLabel.text = transaction.amountCoins.debugDescription
        amountInnovaLabel.textColor = transaction.typeDescriptionColor
        amountUSDLabel.text = String(format: "$ %.2f", transaction.amountCoins.usd)
        myAccountLabel.text = UserController.shared.wallet
        recepientAccountLabel.text = transaction.address
        dateLabel.text = transaction.timestamp.description
        statusLabel.text = transaction.status
        statusLabel.textColor = transaction.statusColor
        descriptionLabel.text = transaction.comment
        
        self.navigationItem.title = transaction.typeDescription
    }
}
