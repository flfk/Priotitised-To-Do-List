//
//  ProjectsVC.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 10/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newProjectTextField: UITextField!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    //MARK: - Action
    
    @IBAction func saveNewProjectButton(_ sender: Any) {
    }
}

extension ProjectsVC: UITextFieldDelegate {
    
    //don't forget in the storyboard to set the textfield delegate to the viewcontroller
    
    //hide keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when the user touches return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newProjectTextField.resignFirstResponder()
        return true
    }
}
