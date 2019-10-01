//
//  ViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/25/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCategory?.name ?? "Items"
        tableView.backgroundColor = UIColor.black
        loadData()
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.textLabel?.textColor = UIColor.white
            
            // Ternary operator
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add new to do", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the user presses add item
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let theItem = Item()
                        theItem.title = textField.text!
                        theItem.dateCreated = Date()
                        
                        // This line links the parent category to the selectedCategory
                        // It also appends the item to the current category
                        currentCategory.items.append(theItem)
                        self.loadData()

                    }
                } catch {
                    print("Error \(error)")
                }
            }
            
        }

        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manipulation Methods
    
    // Delete items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}


// MARK - Search bar methods
// Exension keyword is a better way in making the view controller a delegate
// It makes things more readable & removes the ridcilous amount of Delegates on the top of the page
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            // This allows us to dismiss our keyboard even though there may still
            // be networking calls happening in the background
            // Basically handles multithreading
            DispatchQueue.main.async {
                // Dismisses keyboard
                searchBar.resignFirstResponder()
            }
        }
    }
}

