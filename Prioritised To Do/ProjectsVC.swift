//
//  ProjectsVC.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 10/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

import UIKit
import CoreData

class ProjectsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newProjectTextField: UITextField!
    
    private let segueProjectToDoItems = "ProjectToDoItemsSegue"
    
    //MARK: - Core Data Stack Properties
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        
        //create fetch request
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        print("\(fetchRequest)")
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        print("fetchrequest configuration \(fetchRequest)")
        
        //create fetched results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: adManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("fetchResultsController \(fetchedResultsController)")
        
        //configure fetched results controller
        fetchedResultsController.delegate = self
        
        
        return fetchedResultsController
    }()
    
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //perform data fetch
        attemptFetch()
        
        setupView()

        //set delegate and datasource of tableView to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //add View Controller as observer so when app enters background it saves changes
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    //MARK: - Notification Handling
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try adManagedObjectContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        print("Managed Object Context saved to persitent container")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? MainVC else { return }
        
        //configure view controller
        //destinationViewController.managedObjectContextProjectsVC = persistentContainer.viewContext
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == segueProjectToDoItems {
            //configure View Controller
            destinationViewController.project = fetchedResultsController.object(at: indexPath)
            //deslect the row so that it doesn't remain highlighted
            tableView.deselectRow(at: indexPath, animated: true)
            print("\(fetchedResultsController.object(at: indexPath))")
        }
        
    }
    
    //MARK: - Helper Methods
    
    //UpdateView updates the user interface
    fileprivate func updateView() {
        var hasGoals = false
        
        if let goals = fetchedResultsController.fetchedObjects {
            hasGoals = goals.count > 0
        }
        
        tableView.isHidden = !hasGoals
        introductoryLabel.isHidden = hasGoals
        
        print("updatedview")
    }
    
    private func setupMessageLabel() {
        introductoryLabel.text = "Currently no to projects."
    }
    
    private func setupView() {
        setupMessageLabel()
        
        updateView()
    }
    
    func configure(_ cell: ProjectsCell, at indexPath: IndexPath) {
        
        //fetch project
        let project = fetchedResultsController.object(at: indexPath)
        
        //configure project
        cell.projectNameLabel.text = project.name
    }
    
    func attemptFetch() {
        //self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        print("attemptFetch called")
    }
    
    func emptyTextfieldAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in alert.dismiss(animated: true, completion: nil)} ))
        
        self.present(alert, animated: true, completion: nil)
    }

    func deleteProjectAlert (title: String, message: String, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in alert.dismiss(animated: true, completion: nil)
            //Fetch To Do Item
            let project = self.fetchedResultsController.object(at: indexPath)
            
            //delete To Do Item
            project.managedObjectContext?.delete(project)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Action
    
    @IBAction func saveNewProjectButton(_ sender: Any) {

        //test to see if textfield is empty
        if newProjectTextField.text != "" {
            //create new project
            let newProject = Project(context: adManagedObjectContext)
            
            //configure new project
            newProject.name = newProjectTextField.text
            newProject.createdAt = "\(Date())"
            //clear textfield
            newProjectTextField.text = ""
            
            updateView()
            
        } else {
            emptyTextfieldAlert(title: "", message: "Please enter a project name")
        }
        
        
    }
    
    //MARK: - Table View DataSource Protocol Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = fetchedResultsController.fetchedObjects else { return 0 }
        
        return projects.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsCell.reuseIdentifier, for: indexPath) as? ProjectsCell else {
            fatalError("Unexpected Index Path")
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //send alert for confirmation - note delete method included in alert method
            deleteProjectAlert(title: "", message: "Are you sure you want to delete this project?", indexPath: indexPath)
            
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
 
    //MARK: - NS Fetched Results Controller Delegate Functions
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
        print("controllerdidchangecontent update view")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case.update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ProjectsCell {
                configure(cell, at: indexPath)
            }
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
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
