//
//  ViewController.swift
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
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Core Data Stack Properties
    
    private let persistentContainer = NSPersistentContainer(name: "ToDoItems")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ToDoItem> = {
        //create fetch request
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
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
            //if no errors perform fetch stack on core data stack
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to perform fetch request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
        
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helper Methods
    
    func configure(_ cell: ItemCell, at indexPath: IndexPath) {
        
        //fetch item
        let toDoItem = fetchedResultsController.object(at: indexPath)
        
        //configure item
        cell.itemLabel.text = toDoItem.name
        //XX ITEMCOLOR PLACEHOLDER
        cell.itemPriorityView.backgroundColor = UIColor.green
        cell.starImage.isHidden = !toDoItem.priority
        
    }
    
    //MARK: - Table View Protocl Functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let toDoItems = fetchedResultsController.fetchedObjects else { return 0 }
        
        return toDoItems.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Unexpected Index Path")
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }

}

