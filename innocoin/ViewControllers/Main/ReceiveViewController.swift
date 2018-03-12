//
//  ReceiveViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ReceiveViewController: UIViewController {

    @IBOutlet weak var requestPaymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPaymentButton.applyTheme()
    }

    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
}
