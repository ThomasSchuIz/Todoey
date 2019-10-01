//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/27/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() // This is a valid way in declaring an intro to realm
     
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = 100
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
        // Nil coalescing operator. This just says if the count does end up nil then just return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row].name ?? "No categories added yet"
        
        cell.textLabel?.text = category
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // When the user presses add Category
            let category = Category()
            category.name = textField.text!
            self.saveData(category: category)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        // what will happen once the user clicks the add Category button on our alert
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Data manipulation
    
    // Delete Categorys
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // = Category.fetch.. is a default value if nothing is passed
    func loadData() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

}
