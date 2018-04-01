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

    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var accountStatusLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var anonymousSwitch: UISwitch!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.title = ""
        
        anonymousSwitch.addTarget(self, action: #selector(switcherTapped(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Settings"
        
        populateUser()
    }
    
    private func populateUser() {
        guard UserController.shared.profile != nil else {
            return
        }
        walletLabel.text = UserController.shared.profile.wallet ?? "pending"
        emailLabel.text = UserController.shared.profile.email
        accountStatusLabel.attributedText = NSAttributedString(string: UserController.shared.profile.status.rawValue,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UserController.shared.profile.status.color])
        anonymousSwitch.isOn = UserController.shared.profile.anonymous
        versionLabel.text = "Version \(innovaApp?.version() ?? "1.0")"
    }
    
    // MArk user actions
    private func populateRestResponse(_ response: ServerResponse) {
        switch response {
        case .error(let reason, let title):
            showAlert("\(reason ?? "Unknown")", title: title ?? "Update Error")
        case .success(let data, _):
            do {
                let profile = try JSONDecoder().decode(UserProfileResult.self, from: data)
                UserController.shared.profile = profile.result
                populateUser()
            } catch let error as DecodingError {
                debugPrint("Decoding error: \(error.failureReason ?? error.localizedDescription)")
            } catch let errror as NSError {
                debugPrint("Response Error \(errror.localizedFailureReason ?? errror.localizedDescription)")
            }
        }
    }
    
    @objc private func switcherTapped(_ sender: UISwitch) {
        // First return back switch
        sender.isOn = !sender.isOn
        // Next disable switch to prevent next action
        sender.isEnabled = false
        if !sender.isOn {
            RESTController.shared.makeAnonymous() { [weak self] response in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    self?.populateRestResponse(response)
                }
            }
        } else {
            RESTController.shared.makePublic() { [weak self] response in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    self?.populateRestResponse(response)
                }
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        // Select change password
        case (1,0):
            RouterViewControllers.shared.openChangePassword()

        case (1,1):
            RouterViewControllers.shared.openChangePincode()
        case (1,2):
            RouterViewControllers.shared.openResetPincode()
        case (2,1):
            if UIApplication.shared.canOpenURL(InnovaConstanst.innovaTermsAndServiceLink) {
                UIApplication.shared.open(InnovaConstanst.innovaTermsAndServiceLink)
            }
        case (2,2):
            if UIApplication.shared.canOpenURL(InnovaConstanst.innovePrivacyPolicyLink) {
                UIApplication.shared.open(InnovaConstanst.innovePrivacyPolicyLink)
            }
        default:
            break
        }
    }
}
