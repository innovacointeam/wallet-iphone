//
//  TransactionTableViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 25.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    
    private lazy var container: UIView = {
       let backView = UIView(frame: tableView.frame)
        return backView
    }()
    
    private lazy var emptyController: EmptyTransactionViewController = {
       return storyboard!.instantiateViewController(withIdentifier: "EmptyTransactionViewController") as! EmptyTransactionViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.backgroundColor = UIColor.backgroundStatusBar
        amountLabel.textColor = UIColor.white
    }

    @IBAction func menuTapped(_ sender: Any) {
        guard let app = UIApplication.shared.delegate as? InnocoinApp,
            let mainTabBar = app.mainTabBar else {
                return
        }
        mainTabBar.openMenu()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = TransactionsController.shared.transactionsCount
        if count == 0 {
            tableView.separatorStyle = .none
            tableView.isScrollEnabled = false
            addEmptyController()
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            tableView.isScrollEnabled = true
        }
        return count
    }
    
    private func addEmptyController() {
        add(chield: emptyController, in: container)
        tableView.backgroundView = container
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
