//
//  AddItemVC.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 9/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit
import CoreData

class AddItemVC: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var toDoNameTxtField: UITextField!
    @IBOutlet weak var valueSgmntCntrl: UISegmentedControl!
    @IBOutlet weak var timeSgmntCntrl: UISegmentedControl!
    @IBOutlet weak var consequencesSgmntCntrl: UISegmentedControl!
    
    var toDoItem: ToDoItem?
    
    //Mark: - 
    
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //change fontsize of segmented controllers
        let font = UIFont.systemFont(ofSize: 17)
        valueSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        timeSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        consequencesSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
    
        //prepopulate fields for existing to do items
        if let toDoItem = toDoItem {
            toDoNameTxtField.text = toDoItem.name
            print("Item loaded")
            //PLACEHOLDER for segments
            
        }
        
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func saveButton(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        if let toDoItem = toDoItem {
            //configure to do item
            toDoItem.name = toDoNameTxtField.text
            toDoItem.value = "placeholder"
            toDoItem.time = "placeholder"
            toDoItem.consequences = "placeholder"
            toDoItem.color = "placeholder"
            
        }
        
        if toDoItem == nil {
            //Create To Do Item
            let newToDoItem = ToDoItem(context: managedObjectContext)
            
            //Configure To Do Item
            newToDoItem.name = toDoNameTxtField.text
            newToDoItem.value = "placeholder"
            newToDoItem.time = "placeholder"
            newToDoItem.consequences = "placeholder"
            newToDoItem.color = "placeholder"
        }

        
        
        //Pop view controller
        _ = navigationController?.popViewController(animated: true)
        
    }
    

    // MARK: - Navigation


}

extension AddItemVC: UITextFieldDelegate {
    
    //don't forget in the storyboard to set the textfield delegate to the viewcontroller
    
    //hide keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when the user touches return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toDoNameTxtField.resignFirstResponder()
        return true
    }
}
