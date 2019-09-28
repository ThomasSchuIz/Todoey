//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/27/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This will be responsible for going to the Categorys for that category
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // When the user presses add Category
            
            
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categories.append(category) // Adds Category to the array
            
            // Sets the Categorys to Local storage
            // self.defaults.set(self.CategoryArray, forKey: "TodoListArray")
            self.saveData()
            
            print("Success")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        // what will happen once the user clicks the add Category button on our alert
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Data manipulation
    
    // Delete Categorys
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // This removes Category from the the context/storage
            // This must be done first because we can't delete the cell first
            // otherwise we couldnt find it when removing it from the UI
            context.delete(categories[indexPath.row])
            
            // This removes Category from the array locally
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.saveData()
        }
    }
    
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
    
    // = Category.fetch.. is a default value if nothing is passed
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("error")
        }
        
        self.tableView.reloadData()
    }

}
