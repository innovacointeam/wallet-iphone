//
//  SettingsTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 28.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

// support@innovacoin.info

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationItem.backBarButtonItem?.title = ""
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
            headerTitle.textLabel?.textColor = UIColor.settingsTableSectionHeader
            headerTitle.backgroundView = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.backgroundView = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        for subView in cell.subviews {
            if let button = subView as? UIButton {
                let image = button.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
                button.setImage(image, for: .normal)
                button.tintColor = UIColor.settingsAccessuaryTintColor
                button.setBackgroundImage(nil, for: .normal)
            }
        }

        cell.textLabel?.textColor = UIColor.settingsTintColor
        
    }
    
}
