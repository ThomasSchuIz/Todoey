//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/25/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    // This is how we get the data from AppDelegate
    // We go into the shared singleton
    // Tap into its delegate then cast it as AppDelegate
    // This creates an object of AppDelegate which is what we want
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.backgroundColor = UIColor.black
        
        // This doesn't need a parameter because i gave loadData() a default value
        loadData()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.textLabel?.textColor = UIColor.white
        
        // Ternary operator
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This would be a way to set the value of the title of a cell to the name completed
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // If its true it becomes false, if its false it'll be true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the user presses add item
            
            
            let theItem = Item(context: self.context)
            theItem.title = textField.text!
            theItem.done = false
            self.itemArray.append(theItem) // Adds item to the array
            
            // Sets the items to Local storage
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveData()
            
            // Rerenders the newly added data
            self.tableView.reloadData()
            
            print("Success")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // what will happen once the user clicks the add item button on our alert
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Delete items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // This removes item from the the context/storage
            // This must be done first because we can't delete the cell first
            // otherwise we couldnt find it when removing it from the UI
            context.delete(itemArray[indexPath.row])
            
            // This removes item from the array locally
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.saveData()
        }
    }
    
    //MARK - Model Manipulation Methods
    
    func saveData() {
        do {
            // YOU ALWAYS NEED TO SAVE THE CONTEXT WHEN YOU WANT TO
            // CREATE, UPDATE, OR DELETE FROM THE DB
            try self.context.save()
        } catch {
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // = Item.fetch.. is a default value if nothing is passed
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error")
        }
        

    }
    
}


// MARK - Search bar methods
// Exension keyword is a better way in making the view controller a delegate
// It makes things more readable & removes the ridcilous amount of Delegates on the top of the page
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // This does a DB query for data
        // We use title as what were looking for
        // CONTAINS checks to see if the query contains something
        // [cd] makes it case & accent insensitive
        // %@ inputs the searchBar text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Adds this to the request query
        request.predicate = predicate
        
        // sorts in alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Adds the sort rule to the request query
        // Its an array with only one rule
        request.sortDescriptors = [sortDescriptor]
        
        // This will load the data from the request
        self.loadData(with: request)
    }
}

