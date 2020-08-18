//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Mac Ens on 2020-08-17.
//  Copyright © 2020 Mac Ens. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("categories.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    

    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

          return cell
          
      }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }//end didSelectRowAt
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        do {
            try context.save()
        } catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }//end saveCategories
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
               
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add", style: .default) { (action) in
                   //what will happen when the user clicks the add item button on UIAlert
                   
                   print("Creating new list")
                   
                   let newCategory = Category(context: self.context)
                newCategory.name = textfield.text!
                   self.categoryArray.append(newCategory)
                   
                   
                   self.saveCategories()
                               
                   self.tableView.reloadData()
               }// end let action
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }//end alert.addTextField
               
               
               present(alert, animated: true, completion: nil)
    }//end addButtonPressed
}//end class
