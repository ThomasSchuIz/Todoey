//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/25/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // This creates some local storage
    // FOR LOW DATA TYPE SETTINGS
    let defaults = UserDefaults.standard
    
    // This creates local storage
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath!)
        
        decodeData()
        
        // Optional binding
        // Retreiving data from local storage
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        tableView.backgroundColor = UIColor.black
        
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
        
        // If its true it becomes false, if its false it'll be true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.encodeData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the user presses add item
            
            let theItem = Item()
            theItem.title = textField.text!
            
            self.itemArray.append(theItem) // Adds item to the array
            
            // Sets the items to Local storage
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.encodeData()
            
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
    
    //MARK - Model Manipulation Methods
    
    
    // Encoding the data means turning our custom data model: Item into types that a plist can recongize (string, int, float, etc)
    func encodeData() {
        // Create encoder instead of using defaults
        let encoder = PropertyListEncoder()
        
        do {
            // This encodes the data from itemArray
            let data = try encoder.encode(self.itemArray)
            // This adds data into the dataFile path we created
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    // Decoding data takes the basic types and transforms it back into a custom data type, in this case Item
    func decodeData() {
        // Optional binding
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                // B/c were not specifying an object, in order to refer to the type that is an array of items, we have to write .self
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Fail")
            }
            
        }
    }
    
}

