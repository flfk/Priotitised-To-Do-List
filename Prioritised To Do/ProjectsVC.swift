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
    
    //MARK: - Core Data Stack Properties
    
    private let persistentContainer = NSPersistentContainer(name: "ToDoItems")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //create fetched results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //configure fetched results controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set delegate and datasource of tableView to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //add persistent store to persistent store coordinator
        persistentContainer.loadPersistentStores {(NSPersistentStoreDescription, error) in
            if let error = error {
                print("Unable to load persistent store")
                print("\(error), \(error.localizedDescription)")
            } else {
                
                self.setupView()
                
                //if no errors perform fetch stack on core data stack
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to perform fetch request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
                
            }
        }
        
        //add View Controller as observer so when app enters background it saves changes
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    //MARK: - Notification Handling
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        print("Managed Object Context saved to persitent container")
    }
    
    // MARK: - Navigation
    
    //MARK: - Helper Methods
    
    //UpdateView updates the user interface
    fileprivate func updateView() {
        var hasGoals = false
        
        if let goals = fetchedResultsController.fetchedObjects {
            hasGoals = goals.count > 0
        }
        
        tableView.isHidden = !hasGoals
        introductoryLabel.isHidden = hasGoals
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


    //MARK: - Action
    
    @IBAction func saveNewProjectButton(_ sender: Any) {
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
