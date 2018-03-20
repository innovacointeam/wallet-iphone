//
//  MainTabBarController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit
import MessageUI

class MainTabBarController: UITabBarController {

    private var blur: UIView?
    private var menuContainer: UIView!
    private var menuController: MenuTableViewController!
    private var widthConstrait: NSLayoutConstraint!
    private var leftConstrait: NSLayoutConstraint!
    private var tapOutside: UIGestureRecognizer!
    
    private var isAnimating = false
    private let animationGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapOutside = UITapGestureRecognizer(target: self, action: #selector(tapOutside(_:)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func push(_ controller: UIViewController, animated: Bool) {
        guard let navVC = selectedViewController as? UINavigationController else {
            return
        }
        navVC.visibleViewController?.navigationItem.title = ""
        navVC.pushViewController(controller, animated: animated)
    }
    
    func pop(_ animated: Bool = true) {
        guard let navVC = selectedViewController as? UINavigationController else {
            return
        }
        navVC.popViewController(animated: animated)
    }
    
    func hideMenu() {
        // Hide menu animated
        leftConstrait.isActive = false
        leftConstrait.constant = -250
        leftConstrait.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
                self.menuContainer.frame.origin.x = -250
                self.blur?.alpha = 0
            }, completion: { result in
                // Remove MenuViewController
                self.menuController.willMove(toParentViewController: nil)
                self.menuController.view.removeFromSuperview()
                self.menuController.removeFromParentViewController()
                self.menuContainer.removeFromSuperview()
                self.blur?.removeFromSuperview()
                self.blur?.removeGestureRecognizer(self.tapOutside)
        })
        // Show tabbar
        tabBar.isHidden = false
    }

    func openMenu() {
        // Hide tabbar
        tabBar.isHidden = true
        
        // Create Menu Container View
        blur = selectedViewController?.bluring()
        blur?.alpha = 0
        menuContainer = cretateContainerView()
        
        // Load Menu Controller and add as chield
        menuController = storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
        addChildViewController(menuController)
        menuController.view.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(menuController.view)

        NSLayoutConstraint.activate([
            menuController.view.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            menuController.view.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            menuController.view.topAnchor.constraint(equalTo: menuContainer.topAnchor),
            menuController.view.bottomAnchor.constraint(equalTo: menuContainer.bottomAnchor)
            ])

        menuController.didMove(toParentViewController: self)
        menuContainer.layoutIfNeeded()
        
        // Animate show menu
        leftConstrait.isActive = false
        leftConstrait.constant = 0
        leftConstrait.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.menuContainer.frame.origin.x = 0
            self.blur?.alpha = 1
        }, completion: { _ in
            self.blur?.addGestureRecognizer(self.tapOutside)
        })
    }
    
    private func cretateContainerView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        leftConstrait = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -250)
        
        NSLayoutConstraint.activate([
            leftConstrait,
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.widthAnchor.constraint(equalToConstant: 250)
            ])
        return containerView
    }
    
    @objc private func tapOutside(_ sender: UITapGestureRecognizer) {
        hideMenu()
    }
    
    
    func logout() {
        showCustomAlert(title: "Are you sure that you want to leave the Innova Wallet?", message: "", action: "Logout", delegate: self)
    }
    
    func shareInnova() {
        let firstActivityItem = "Innova wallet"
        let secondActivityItem = URL(string: "https://innovacoin.info")!
        
        var activities: [Any] = [firstActivityItem, secondActivityItem]
        if let image = UIImage.appIcon {
            activities.append(image)
        }
        
        let activityViewController = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        
        if let popover = activityViewController.popoverPresentationController {
            // This lines is for the popover you need to show in iPad
            popover.sourceView = activityViewController.view
            popover.permittedArrowDirections = .any
            popover.sourceRect = activityViewController.view.frame
        }
        present(activityViewController, animated: true, completion: nil)
    }
}

extension MainTabBarController: MFMailComposeViewControllerDelegate {
    
    func sendMailToSupport() {
        guard  MFMailComposeViewController.canSendMail() else {
            let message = """
            Cannot send mail from this device.
            Please use another way.
            Support email: \(InnovaConstanst.supportEmail)
            """
            showAlert(message, title: "")
            return
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([InnovaConstanst.supportEmail])
        mail.setSubject("Wallet ID: \(UserController.shared.wallet ?? UserController.shared.email), status: \(UserController.shared.status.rawValue)")
        
        self.present(mail, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension MainTabBarController: AlertViewControllerDelegate {
    
    func didCancel() {
        
    }
    
    func didAction(_ name: String) {
        UserController.shared.logout()
        innovaApp?.setRoot(storyboard!.loginViewController(), options: .transitionFlipFromLeft)
    }
    
    
}
