//
//  PincodeViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 27.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class PincodeViewController: UIViewController {

    static let pefferedSize = CGSize(width: 300, height: 420)
    
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var thirthNumberLabel: UILabel!
    @IBOutlet weak var forthNumberLabel: UILabel!
    @IBOutlet weak var fifthNumberLabel: UILabel!
    @IBOutlet weak var sixthNumberLabel: UILabel!
    
    private lazy var numberLabels = [firstNumberLabel, secondNumberLabel, thirthNumberLabel,
                                forthNumberLabel, fifthNumberLabel, sixthNumberLabel]
    
    private var pincode: String = ""
    var delegate: PincodeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNumberLabel.text = "✻"
        secondNumberLabel.text = "✻"
        thirthNumberLabel.text = "✻"
        forthNumberLabel.text = "✻"
        fifthNumberLabel.text = "✻"
        sixthNumberLabel.text = "✻"
        pincode = ""
    }
    
    @IBAction func buttonTapped(_ sender: NumberButton) {
        switch sender.tag {
        case 100:
            delegate?.didEnter(pin: nil)
        case 101:
            pincode = String(pincode.dropLast())
        default:
            pincode += sender.tag.description
        }
        
        if pincode.count == 6 {
            delegate?.didEnter(pin: pincode)
            view.isUserInteractionEnabled = false
        }
        
        // Update UI
        var index = 0
        for number in pincode {
            numberLabels[index]?.text = String(number)
            index += 1
        }
        for i in index..<6 {
            numberLabels[i]?.text = "✻"
        }
    }
    
}
