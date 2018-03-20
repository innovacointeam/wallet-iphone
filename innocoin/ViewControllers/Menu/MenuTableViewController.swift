//
//  MenuTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit
import MessageUI

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        innovaApp?.mainTabBar?.hideMenu()

        switch indexPath.row {
        // Address book
        case 0:
            RouterViewControllers.shared.openAddressBook()
            return
        // Settings
        case 1:
            let controller = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController")
            innovaApp?.mainTabBar?.push(controller, animated: false)
        // Share App
        case 2:
           
           innovaApp?.mainTabBar?.shareInnova()
        // Write to Support
        case 3:
            innovaApp?.mainTabBar?.sendMailToSupport()
        // Logout
        case 4:
            innovaApp?.mainTabBar?.logout()
        default:
           return
        }
    }
}



