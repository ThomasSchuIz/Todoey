//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/25/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = ["One", "Two", "Three"]
    
    // This creates some local storage
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Optional chaining
        // Retreiving data from local storage
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
        tableView.backgroundColor = UIColor.black
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the user presses add item
            
            self.itemArray.append(textField.text!) // Adds item to the array
            
            // Sets the items to Local storage
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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
    
}

