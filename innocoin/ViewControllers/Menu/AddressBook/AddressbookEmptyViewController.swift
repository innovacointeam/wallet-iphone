//
//  AddressbookEmptyViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 02.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class AddressbookEmptyViewController: UIViewController {

    @IBOutlet weak var addContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContactButton.applyTheme()
        view.backgroundColor = UIColor.backgroundViewController
        navigationItem.title = "Address Book"
        navigationItem.backBarButtonItem?.title = ""
    }


    @IBAction func addContactTapped(_ sender: Any) {
    }
}
