//
//  ContactsTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit
import CoreData


class ContactsTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var fetchController: NSFetchedResultsController<Contact> = {
        let controller = DataManager.shared.contactsFetchController()
        controller.delegate = self
        return controller
    }()
    
    private lazy var emptyController: AddressbookEmptyViewController = {
       let controller = UIStoryboard.addressBookEmptyViewController
       return controller
    }()
    
    private let emptyView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? fetchController.performFetch()
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Address Book"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addContact))
        tableView.reloadData()
    }

    // MARK: - User action observer
    @objc private func addContact() {
        RouterViewControllers.shared.openAddContact()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchController.fetchedObjects?.count ?? 0
        if count == 0 {
            searchBar.isHidden = true
            tableView.backgroundView = emptyView
            tabBarController?.tabBar.isHidden = true
            navigationItem.rightBarButtonItem = nil
            add(chield: emptyController, in: emptyView)
        } else {
            tableView.backgroundView = nil
            searchBar.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addContact))
            tabBarController?.tabBar.isHidden = false
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else {
            fatalError("Failed to load ContactTableViewCell")
        }
        cell.contact = fetchController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RouterViewControllers.shared.preview(contact: fetchController.object(at: indexPath))
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _ , indexPath in
            if let contact = self?.fetchController.object(at: indexPath) {
                DataManager.shared.delete(contact: contact)
            }
        }
        return [delete]
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contact = fetchController.object(at: indexPath)
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] action, source, completion in
            let alert = UIAlertController(title: "Delete Contact", message: "Delete \(contact.fullName ?? "Noname")", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                DataManager.shared.delete(contact: contact)
                completion(true)
            }
            alert.addAction(delete)
            alert.addAction(cancel)
            self?.present(alert, animated: true, completion: nil)
        }
        delete.image = #imageLiteral(resourceName: "trashIcon")
        delete.backgroundColor = UIColor.redInnova
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension ContactsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
