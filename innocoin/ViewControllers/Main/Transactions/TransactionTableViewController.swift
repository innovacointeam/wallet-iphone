//
//  TransactionTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshCommentLabel: UILabel!
    
    private lazy var container: UIView = {
       let backView = UIView(frame: tableView.frame)
        return backView
    }()
    
    lazy var fetchController: NSFetchedResultsController<Transaction> = {
        let controller = DataManager.shared.transactionsFetchController()
        controller.delegate = self
        return controller
    }()
    
    private lazy var emptyController: EmptyTransactionViewController = {
       return storyboard!.instantiateViewController(withIdentifier: "EmptyTransactionViewController") as! EmptyTransactionViewController
    }()
    private let emptyView = UIView()
    private let offsetToRefresh: CGFloat = 150
    private var headerView: UIView!
    private let effectiveHeight: CGFloat = 44
    private let rowHeigh: CGFloat =  60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.backgroundColor = UIColor.backgroundStatusBar
        amountLabel.textColor = UIColor.white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        headerView.frame.origin.y = -effectiveHeight
        headerView.clipsToBounds = true
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        tableView.tableFooterView = UIView()
        amountLabel.text = UserController.shared.wallet?.balance.humanDescription
        try? fetchController.performFetch()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeader()
        refreshCommentLabel.text = RESTController.shared.online ? "Updating transactions. Please wait..." : "Innovacoin site unavaiable. Please try late"
        
        fetchTransactions()
    }

    // MARK: - User actions
    private func fetchTransactions() {
        RESTController.shared.refreshTransactions() { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.contentInset = UIEdgeInsets(top: self?.effectiveHeight ?? 0, left: 0, bottom: 0, right: 0)
                self?.tableView.isScrollEnabled = true
                self?.amountLabel.text = UserController.shared.wallet.balance.humanDescription
            }
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }

    @IBAction func qrcodeTapped(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = fetchController.fetchedObjects?.count ?? 0
        count += UserController.shared.pending.count
        if count == 0 {
            tableView.backgroundView = emptyView
            add(chield: emptyController, in: emptyView)
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    private func addEmptyController() {
        add(chield: emptyController, in: container)
        tableView.backgroundView = container
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        // correct row for pending
        var fetchIndex = indexPath
        fetchIndex.row -= UserController.shared.pending.count
        if indexPath.row < UserController.shared.pending.count {
            cell.pending = UserController.shared.pending[indexPath.row]
        } else {
            cell.transaction = fetchController.object(at: fetchIndex)
        }
//        cell.populateTransaction()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeigh
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard.transactionDetailsViewController
        var fetchIndex = indexPath
        fetchIndex.row -= UserController.shared.pending.count
        if indexPath.row < UserController.shared.pending.count {
            detailsVC.pending = UserController.shared.pending[indexPath.row]
        } else {
            detailsVC.transaction = fetchController.object(at: fetchIndex)
        }
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) as? TransactionTableViewCell,
            let pending = cell.pending, pending.status == .failed else {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TransactionTableViewCell,
            let pending = cell.pending else {
                return nil
        }
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] action, source, completion in
            let alert = UIAlertController(title: "Delete", message: "Delete failed transaction?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                completion(true)
                RESTController.shared.delete(txid: pending.id) { _ in
                    DispatchQueue.main.async { [weak self] in
                        self?.fetchTransactions()
                    }
                }
            }
            alert.addAction(delete)
            alert.addAction(cancel)
            self?.present(alert, animated: true, completion: nil)
        }
        delete.image = #imageLiteral(resourceName: "trashIcon")
        delete.backgroundColor = UIColor.redInnova
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
    private func updateHeader() {
        // Nothing to do if don't set table view header
        guard headerView != nil else {
            return
        }
        let currentOffset = tableView.contentOffset.y
        var frame = CGRect(x: 0, y: currentOffset, width: tableView.bounds.width, height: effectiveHeight)
        if (currentOffset < 0) && (abs(currentOffset) > effectiveHeight)  {
            frame.size.height = abs(currentOffset)
            if frame.size.height >= offsetToRefresh {
                tableView.contentInset = UIEdgeInsets(top: abs(currentOffset), left: 0, bottom: 0, right: 0)
                tableView.isScrollEnabled = false
                fetchTransactions()
            }
        }
        headerView.frame = frame
        headerView.bounds.height > effectiveHeight ? refreshIndicator.startAnimating() : refreshIndicator.stopAnimating()
    }
}


extension TransactionTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO: - Create Insert, Reload  methods in the future.
        tableView.reloadData()
    }
    
}
