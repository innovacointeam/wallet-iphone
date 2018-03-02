//
//  MenuTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp else {
            fatalError("Failed to load InnocoinApp")
        }
        
        app.mainTabBar?.hideMenu()
        
        var controller: UIViewController
        switch indexPath.row {
        case 0:
            controller = storyboard!.instantiateViewController(withIdentifier: "AddressbookEmptyViewController")
        case 1:
            controller = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController")
        default:
           return
        }
        
        app.mainTabBar?.push(controller, animated: false)
    }

}
