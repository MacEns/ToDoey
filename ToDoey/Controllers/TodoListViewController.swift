//
//  ViewController.swift
//  ToDoey
//
//  Created by Mac Ens on 2020-08-08.
//  Copyright © 2020 Mac Ens. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }//selectedCategory

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }//viewDidLoad()
    
    
      //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator (basically a switch statement)
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        item.isChecked = !item.isChecked
        

        
        
        saveItems()
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }//end didSelectRowAt
    
    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the add item button on UIAlert

            
            print("Creating new item")
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.isChecked = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            
            self.saveItems()
                        
            self.tableView.reloadData()
        }// end let action
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textfield = alertTextField
        }//end alert.addTextField
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }//addButtonPressed
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do{
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }//do catch
    }//end saveItems
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
        itemArray = try context.fetch(request)
            //print("Items loaded.")
        } catch {
            print("Error fetching data from context \(error)")
        }//do catch
        tableView.reloadData()
    }//end loadItems

    
    func deleteItem(indexPath : IndexPath) {
        //delete row
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
    }//deleteItem
    
}//end TodoListViewController Class


//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //print("Loading items with title CONTAINS \(searchBar.text!)")
        loadItems(with: request)
        
    }//searchBarButtonClicked
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }//DispatchQueue
        }//end if
    }//searchBar textDidChange
    
}//end extension
