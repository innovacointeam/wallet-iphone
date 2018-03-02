//
//  QuestionsTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 23.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

protocol QuestionTableViewControllerDelegate {
    func didSelect(_ question: Int)
}

class QuestionsTableViewController: UITableViewController {
    
    static let preferedSize = CGSize(width: 320, height: 200)
    
    var delegate: QuestionTableViewControllerDelegate?
    
    private var gesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gesture = UITapGestureRecognizer(target: self, action: #selector(tappetInTable(_:)))
        tableView.addGestureRecognizer(gesture)
        
        tableView.tableFooterView = nil
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor.backgroundViewController
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoginController.shared.questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath)
        cell.textLabel?.text = LoginController.shared.questions[indexPath.row]
        cell.backgroundView = nil
        cell.contentView.backgroundColor = UIColor.backgroundViewController
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("choice question: \(LoginController.shared.questions[indexPath.row])")
        delegate?.didSelect(indexPath.row)
    }
    
    @objc private func tappetInTable(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: location) {
            delegate?.didSelect(indexPath.row)
        } else {
            delegate?.didSelect(-1)
        }
    }

}
