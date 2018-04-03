//
//  ResetPasswordFinishViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class ResetPasswordFinishViewController: UIViewController {

    @IBOutlet weak var gotoSigninButton: UIButton!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gotoSigninButton.applyTheme()
    }
    
    @IBAction func gotoSinginTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
