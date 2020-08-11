//
//  ViewController.swift
//  ToDoey
//
//  Created by Mac Ens on 2020-08-08.
//  Copyright © 2020 Mac Ens. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let newItem = Item()
        newItem.setItemName(itemName: "Item 1")
        itemArray.append(newItem)

        
        loadItems()
        
    }//viewDidLoad()
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.getItemName()
        
        //Ternary Operator (basically a switch statement)
        cell.accessoryType = item.isItemChecked() ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        print(item.getItemName())
        
        item.setIsChecked(isItemChecked: !item.isItemChecked())
        
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the add item button on UIAlert

            
            print("Creating new item")
            
            let newItem = Item()
            newItem.setItemName(itemName: textfield.text!)
            self.itemArray.append(newItem)
            print("New Item appending to array")
            
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
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding array, \(error)")
        }
        
        
    }//end saveItems
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!){
          let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data")
            }//catch
        }
        
    }//end loadItems
}

