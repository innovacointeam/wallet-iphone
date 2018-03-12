//
//  PreviewContactViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 08.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class PreviewContactViewController: UIViewController {

    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topBarView: UIView!
    
    var contact: Contact! {
        didSet {
            guard contact != nil else {
                return
            }
            populateContact()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.viewControllerLigthBackground
        
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "edit"), style: .plain, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = editButton
        
        avatarContainerView.layer.cornerRadius = 5
        avatarContainerView.backgroundColor = UIColor.white
        avatarContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        avatarContainerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        avatarContainerView.clipsToBounds = true
        avatarContainerView.layer.masksToBounds = false
        
        buttonsContainer.applyGradient(colours: [.startButtonGradient, .endButtonGradient])
        buttonsContainer.layer.cornerRadius = 5.0
        buttonsContainer.clipsToBounds = true
        
        topBarView.backgroundColor = UIColor.backgroundStatusBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = ""
        populateContact()
    }
    
    // MARK: - User actions
    @objc private func editContact() {
        
    }
    
    @IBAction func deleteContactTapped(_ sender: Any) {
        guard let contact = contact else {
            return
        }
        let alert = UIAlertController(title: contact.fullName, message: "Delete this contact?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DataManager.shared.delete(contact: contact)
            RouterViewControllers.shared.pop()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendInnovaTapped(_ sender: Any) {
    }
    
    
    private func populateContact() {
        nameLabel?.text = contact.fullName
        walletLabel?.text = contact.wallet
    }
}
