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

        switch indexPath.row {
        case 0:
            RouterViewControllers.shared.openAddressBook()
            return
        case 1:
            let controller = storyboard!.instantiateViewController(withIdentifier: "SettingsTableViewController")
            app.mainTabBar?.push(controller, animated: false)
        default:
           return
        }
    }

}
