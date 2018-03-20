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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.backgroundColor = UIColor.backgroundStatusBar
        amountLabel.textColor = UIColor.white
        refreshControl = UIRefreshControl()
        let text = "Updating from server. Please wait..."
        let refreshTitle = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderTextColor])
        refreshControl?.backgroundColor = UIColor.backgroundStatusBar
        refreshControl?.tintColor = UIColor.placeholderTextColor
        
        refreshControl?.attributedTitle = refreshTitle
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.tableHeaderView?.addSubview(refreshControl!)
        tableView.tableFooterView = UIView()
        
        try? fetchController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RESTController.shared.refreshTransactions()
    }

    // MARK: - User actions
    @objc private func refresh(_ sender: AnyObject) {
        RESTController.shared.refreshTransactions() { [weak self] in
            self?.refreshControl?.endRefreshing()
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
        let count = fetchController.fetchedObjects?.count ?? 0
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
        cell.transaction = fetchController.object(at: indexPath)
        cell.populateTransaction()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard.transactionDetailsViewController
        detailsVC.transaction = fetchController.object(at: indexPath)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension TransactionTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO: - Create Insert, Reload  methods in the future.
        tableView.reloadData()
    }
    
}
