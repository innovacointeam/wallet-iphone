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
    @IBOutlet weak var qrCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiverField.setPlaceholder(color: UIColor.placeholderTextColor)
        descriptionField.setPlaceholder(color: UIColor.placeholderTextColor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.applyTheme()
    }
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }
    
    @IBAction func qrCodeTapped(_ sender: Any) {
        let qrController = storyboard!.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        qrController.delegate = self
        present(qrController, animated: true, completion: nil)
    }
    
}

extension SendViewController: QRScannerViewControllerDelegate {
    
    func didFail(reason: String) {
        showAlert(reason, title: "QRCode scanning")
    }
    
    func didFinish(code: String?) {
        guard let code = code else {
            return
        }
        receiverField.text = code
    }
    
}
