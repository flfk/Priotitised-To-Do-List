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
    
    //create variables to store the index values of segmented controls
    var valueIndex: Int?
    var timeIndex: Int?
    var consequencesIndex: Int?
    
    //Mark: - 
    
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set default value of index to the average
        valueIndex = 1
        timeIndex = 1
        consequencesIndex = 1
        
        //update the segment views
        updateSgmntCntrls()
    
        //change fontsize of segmented controllers
        let font = UIFont.systemFont(ofSize: 17)
        valueSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        timeSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        consequencesSgmntCntrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
    
        //prepopulate fields for existing to do items
        if let toDoItem = toDoItem {
            toDoNameTxtField.text = toDoItem.name

            //PLACEHOLDER for segments
            
        }
        
        
        
    }
    
    //MARK: - Helper Methods
    
    //create a function to update the selector views based on the index values
    
    func updateSgmntCntrls() {
        valueSgmntCntrl.selectedSegmentIndex = valueIndex!
        timeSgmntCntrl.selectedSegmentIndex = timeIndex!
        consequencesSgmntCntrl.selectedSegmentIndex = consequencesIndex!
        
    }
    
    //MARK: - Actions
    
    @IBAction func valueSgmntCntrlAction(_ sender: Any) {
        
        switch valueSgmntCntrl.selectedSegmentIndex {
        case 0:
            print("Low")
        case 1:
            print("Moderate")
        case 2:
            print("High")
        default:
            break
        }
    }
    
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        if let toDoItem = toDoItem {
            //configure to do item
            toDoItem.name = toDoNameTxtField.text
            toDoItem.value = Int16(valueSgmntCntrl.selectedSegmentIndex)
            toDoItem.time = Int16(timeSgmntCntrl.selectedSegmentIndex)
            toDoItem.consequences = Int16(consequencesSgmntCntrl.selectedSegmentIndex)
            toDoItem.color = Int16(valueSgmntCntrl.selectedSegmentIndex) + Int16(timeSgmntCntrl.selectedSegmentIndex) + Int16(consequencesSgmntCntrl.selectedSegmentIndex)
            
        }
        
        if toDoItem == nil {
            //Create To Do Item
            let newToDoItem = ToDoItem(context: managedObjectContext)
            
            //Configure To Do Item
            newToDoItem.name = toDoNameTxtField.text
            newToDoItem.value = Int16(valueSgmntCntrl.selectedSegmentIndex)
            newToDoItem.time = Int16(timeSgmntCntrl.selectedSegmentIndex)
            newToDoItem.consequences = Int16(consequencesSgmntCntrl.selectedSegmentIndex)
            newToDoItem.color = Int16(valueSgmntCntrl.selectedSegmentIndex) + Int16(timeSgmntCntrl.selectedSegmentIndex) + Int16(consequencesSgmntCntrl.selectedSegmentIndex)
        
            print("\(newToDoItem.value)")
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
