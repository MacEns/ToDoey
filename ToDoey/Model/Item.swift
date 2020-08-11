//
//  Item.swift
//  ToDoey
//
//  Created by Mac Ens on 2020-08-09.
//  Copyright © 2020 Mac Ens. All rights reserved.
//

import Foundation


class Item: Codable {
    
    private var title: String = ""
    private var isChecked: Bool = false
    
    
    //function to return the item name
    func getItemName() -> String {
        return title
    }//getItemName
    
    //function to set the item name
    func setItemName(itemName: String) {
        title = itemName
    }//setItemName
    
    //function to return the isChecked status
    func isItemChecked() -> Bool{
        return isChecked
    }//isChecked()
    
    //function to set the item name
    func setIsChecked(isItemChecked : Bool) {
        self.isChecked = isItemChecked
    }//setIsItemChecked()
    
    
    
    
}//end class
