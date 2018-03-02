//
//  SendViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var receiverField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiverField.setPlaceholder(color: UIColor.placeholderTextColor)
        descriptionField.setPlaceholder(color: UIColor.placeholderTextColor)
        continueButton.applyTheme()
    }
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
}
