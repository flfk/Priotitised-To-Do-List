//
//  MainVC.swift
//  Prioritised To Do
//
//  Created by Felix Kramer on 9/6/17.
//  Copyright © 2017 Felix Kramer. All rights reserved.
//

//  Backend based off tutorial from https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3/

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var introductoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let segueAddToDoItem = "AddToDoItemSegue"
    private let segueEditToDoItem = "EditToDoItemSegue"
    
    //MARK: - Core Data Stack Properties
    
    var project: Project?
    
    //private let persistentContainer = NSPersistentContainer(name: "ToDoItems")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ToDoItem> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        //configure fetch request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "color", ascending: false)]
        
        //predicate fetch request for project
        fetchRequest.predicate = NSPredicate(format: "project.name == %@", self.project!.name!)
        
        
        
        //create fetched results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: adManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //configure fetched results controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title of view controller
        title = project?.name
        
        //fetch data
        attemptFetch()
        
        self.setupView()
        
        //set delegate and datasource of tableView to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //add View Controller as observer so when app enters background it saves changes
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? AddItemVC else { return }
        
        //configure view controller
        //destinationViewController.managedObjectContext = managedObjectContextProjectsVC
        destinationViewController.project = project
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == segueEditToDoItem {
            //configure View Controller
            destinationViewController.toDoItem = fetchedResultsController.object(at: indexPath as IndexPath)
            print("printing toDoItem to be sent: \(fetchedResultsController.object(at: indexPath as IndexPath))")
            //destinationViewController.toDoItem = project?.toDoItems?.mutableSetValue(forKey: "names")
            //fetchedResultsController.object(at: indexPath)
            //deslect the row so that it doesn't remain highlighted
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
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
    
    
    //MARK: - Helper Methods
    
    //UpdateView updates the user interface
    fileprivate func updateView() {
        var hasToDoItems = false
        
        if let toDoItems = project?.toDoItems {
            hasToDoItems = toDoItems.count > 0
        }
        
        tableView.isHidden = !hasToDoItems
        introductoryLabel.isHidden = hasToDoItems
    }
    
    private func setupMessageLabel() {
        introductoryLabel.text = "Currently no to do's."
    }
    
    private func setupView() {
        setupMessageLabel()
        
        updateView()
    }
    
    func configure(_ cell: ItemCell, at indexPath: IndexPath) {
        
        //fetch item
        //let toDoItem = fetchedResultsController.object(at: indexPath)
//        guard let toDoItems = project?.toDoItems?.allObjects else { return }
//        let toDoItem = toDoItems[indexPath.row]
//        print("toDoItems: \(toDoItems)")
//        print("toDoItem: \(toDoItem)")
        
       let toDoItem = fetchedResultsController.object(at: indexPath as IndexPath)
  
        
        //configure item
        cell.itemLabel.text = toDoItem.name
        let image = "\(toDoItem.color)"
        cell.colorImage.image = UIImage(named: image)

        
    }
    
    func attemptFetch() {
        //self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        updateView()
    }
    
    //MARK: - Table View DataSource Protocol Functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let toDoItems = fetchedResultsController.fetchedObjects else { return 0 }
        guard let toDoItems = project?.toDoItems else { return 0 }
        
        return toDoItems.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Unexpected Index Path")
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Fetch To Do Item
            //let toDoItem = fetchedResultsController.object(at: indexPath)
            //let toDoItem = project.
            //let toDoItemKey = tableView.indexPathForSelectedRow
            
            //delete To Do Item
            //toDoItem.managedObjectContext?.delete(toDoItem)
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
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

