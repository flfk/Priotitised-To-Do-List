//
//  ProjectsVC.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 10/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newProjectTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation

    //MARK: - Action
    
    @IBAction func saveNewProjectButton(_ sender: Any) {
    }
}
