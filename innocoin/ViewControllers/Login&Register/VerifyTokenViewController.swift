//
//  VerifyTokenViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 02.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class VerifyTokenViewController: UIViewController {

    @IBOutlet weak var sendVerifyButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendVerifyButton.applyTheme()
        view.backgroundColor = UIColor.backgroundViewController
        
        let ok = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(backToLogin))
        navigationItem.rightBarButtonItem = ok
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Verify Account"
    }
    
    @IBAction func sendVerifyTapped(_ sender: Any) {
        sendVerifyButton.isEnabled = false
        RESTController.shared.verify() { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .error(let reason, let code):
                    self?.showAlert("\(code ?? 0): \(reason ?? "Unknown error")", title: "Innova") {
                        self?.sendVerifyButton.isEnabled = true
                    }
                case .success:
                    self?.showAlert("Verying token send", title: "Innova") {
                        self?.backToLogin()
                    }
                }
            }
        }
    }
    
    @objc private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
}
