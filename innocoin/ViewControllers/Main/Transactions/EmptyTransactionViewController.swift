//
//  EmptyTransactionViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 26.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class EmptyTransactionViewController: UIViewController {

    @IBOutlet weak var receivedInnovaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        receivedInnovaButton.applyTheme()
    }
    
    @IBAction func receiveButtonTapped(_ sender: Any) {
        innovaApp?.mainTabBar?.selectedIndex = 3
    }
}
