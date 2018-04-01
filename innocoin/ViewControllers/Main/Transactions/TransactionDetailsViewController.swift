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
    @IBOutlet weak var feeLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            type = transaction.type
        }
    }
    var pending: PendingTransaction! {
        didSet {
            type = .pending
        }
    }
    
    private var type: TransactionType = .received
    
    enum VisibleRows: Int {
        
        static let showPending = [1, 3, 4, 5, 7]
        static let showReceived = [0, 1, 3, 4, 5, 6, 7]
        
        case pending = 5
        case received = 7
        case send =  8
        
        
        func indexPath(_ indexPath: IndexPath) -> IndexPath {
            switch self {
            case .pending:
                let row = VisibleRows.showPending[indexPath.row]
                return IndexPath(row: row, section: indexPath.section)
            case .received:
                let row = VisibleRows.showReceived[indexPath.row]
                return IndexPath(row: row, section: indexPath.section)
            default:
                return indexPath
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(copyID(_:)))
        longTap.minimumPressDuration = 1
        idLabel.isUserInteractionEnabled = true
        idLabel.addGestureRecognizer(longTap)
        
        let copyAddressTap = UILongPressGestureRecognizer(target: self, action: #selector(copyAddress(_:)))
        copyAddressTap.minimumPressDuration = 1
        myAccountLabel.isUserInteractionEnabled = true
        myAccountLabel.addGestureRecognizer(copyAddressTap)
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
        amountInnovaLabel.text = transaction.amountCoins.humanDescription
        amountInnovaLabel.textColor = transaction.mainColor
        amountTitleLabel.textColor = transaction.mainColor
        let usd: USDCoin = MarketPriceController.shared.convert(from: transaction.amountCoins)
        amountUSDLabel.text = usd.humanDescription
        feeLabel.text = InnovaCoin(transaction.fee).humanDescription
        
        myAccountLabel.text = transaction.address
        dateLabel.text = transaction.timestamp.description
        statusLabel.text = transaction.status.description
        statusLabel.textColor = transaction.statusColor
        confirmationsCountLabel.textColor = transaction.statusColor
        let count = transaction.confirmations > InnovaConstanst.maxConfirmationsCountToShow ? InnovaConstanst.maxConfirmationsCountToShow : transaction.confirmations
        confirmationsCountLabel.text = "\(count)/\(InnovaConstanst.maxConfirmationsCountToShow)"

        descriptionLabel.text = transaction.comment
        self.navigationItem.title = transaction.type.description
        
        // Add pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.placeholderTextColor
        refreshControl?.backgroundColor = UIColor.backgroundStatusBar
        refreshControl?.attributedTitle = NSAttributedString(string: "Update transaction...",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        refreshControl?.addTarget(self, action: #selector(updateTransaction), for: .valueChanged)
    }
    
    

    
    @objc private func updateTransaction() {
        guard let txid = transaction?.id else {
            return
        }
        RESTController.shared.update(txid: txid) { response in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl?.endRefreshing()
                switch response {
                case .error(let reason, _):
                    debugPrint("Error \(reason ?? "unknown")")
                case .success(let data, _):
                    do {
                        if let newTransaction = try JSONDecoder().decode(TXTransactionReponse.self, from: data).transaction {
                            self?.update(newTransaction)
                        }
                    } catch let error as DecodingError {
                        debugPrint("Failed decoding \(error.localizedDescription): \(error.failureReason ?? "")")
                    } catch let error as NSError {
                        debugPrint(error.localizedFailureReason ?? error.localizedDescription)
                    }
                }
            }
        }
        refreshControl?.endRefreshing()
    }
    
    private func update(_ newTransaction: InnovaTransaction) {
        transaction?.populate(newTransaction)
        populateTransaction()
        DataManager.shared.save()
    }
    
    
    // MARK: - TableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .pending:
            return VisibleRows.pending.rawValue
        case .received:
            return VisibleRows.received.rawValue
        case .send:
            return VisibleRows.send.rawValue
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .pending:
            let newIndex = VisibleRows.pending.indexPath(indexPath)
            return super.tableView(tableView, cellForRowAt: newIndex)
        case .received:
            let newIndex = VisibleRows.received.indexPath(indexPath)
            return super.tableView(tableView, cellForRowAt: newIndex)
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    // MARK: - User gestures
    @objc private func copyID(_ gesture: UILongPressGestureRecognizer) {
        guard let id = transaction.id else {
            return
        }
        UIPasteboard.general.string = id
        showAlert(id, title: "Copy to pasteboard")
    }
    
    // MARK: - User gestures
    @objc private func copyAddress(_ gesture: UILongPressGestureRecognizer) {
        guard let address = transaction.address else {
            return
        }
        UIPasteboard.general.string = address
        showAlert(address, title: "Copy to pasteboard")
    }
}
