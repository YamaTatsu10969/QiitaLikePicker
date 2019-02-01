//
//  ListViewController.swift
//  QuitaLikePicker
//
//  Created by 山本竜也 on 2019/1/28.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ArticleTitle = [String]()
    var url = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ArticleTitle[indexPath.row]
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "showQiitaWebsite" {
            let webVC = segue.destination as! WebViewController
            if let indexPathRow = self.tableView.indexPathForSelectedRow?.row{
                webVC.urlString = url[indexPathRow]
                //webVC.editTask = taskCollection.tasks[indexPathRow]
            }
        }
        
    }
    

}
