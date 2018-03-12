//
//  UIViewController+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 22.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

import UIKit

extension UIViewController {
    
    var innovaApp: InnocoinApp? {
        return UIApplication.shared.delegate as? InnocoinApp
    }
    
    static func loadFromStoryboard(type controllerType: UIViewController) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: controllerType))
    }
    
    @discardableResult func hideKeyboard() -> UIGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        return tap
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func showAlert(_ message: String, title: String = "Error in input", completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title ,message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(ok)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    @discardableResult func bluring() -> UIVisualEffectView {
        let blur = UIBlurEffect(style: .light)
        let blurEffect = UIVisualEffectView(effect: blur)

        blurEffect.frame = view.frame
        view.addSubview(blurEffect)
        return blurEffect
    }
    
    func add(chield controller: UIViewController, in container: UIView) {
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: container.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
        container.layoutIfNeeded()
    }
    
    func remove(chield controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    @discardableResult func showActivityIndicatory(in parentView: UIView, text: String? = nil) -> UIView {
        var size = CGSize.zero
        let label = UILabel()
        if let text = text {
            label.text = text
            label.font = UIFont.preferredFont(forTextStyle: .title3)
            label.textColor = UIColor.white
            size = label.intrinsicContentSize
        }
        
        let loadingView: UIView = UIView()
        let width = size.width + 40 < 80 ? 80 : size.width + 40
        loadingView.frame = CGRect(x: 0, y: 0, width: width, height: 80 + size.height)
        loadingView.center = parentView.center
        loadingView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2 - (size.height / 2))
        if text != nil {
            label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            label.center = actInd.center
            label.center.y += 40
            loadingView.addSubview(label)
        }
        loadingView.addSubview(actInd)
        parentView.addSubview(loadingView)
        actInd.startAnimating()
        return loadingView
    }
    
    @discardableResult func showCustomAlert(title: String, message: String, action: String, delegate: AlertViewControllerDelegate) -> AlertViewController {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.title  = title
        controller.action = action
        controller.text = message
        controller.delegate = delegate
        present(controller, animated: true, completion: nil)
        return controller
    }
}
