//
//  MyWardrobeViewController.swift
//  styleUP
//
//  Created by Doğa Barsgan on 6/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  My Wardrobe where clothing items are listed

import UIKit
import os.log
import FirebaseAuth
import FirebaseDatabase





var myWardrobe = [ClothingItem]()


var addedItems = [ClothingItem]()

class MyWardrobeViewController: UITableViewController{
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    

    @IBOutlet weak var testButton: UIBarButtonItem!
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        
        navigationItem.rightBarButtonItems = [editButtonItem, addButton, testButton]
        
        
        // Load any saved clothing items, otherwise do nothing.
        //if let savedClothingItems = loadClothingItems() {
            //myWardrobe += savedClothingItems
        //}
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   
//---------------------------------------------------------------------------

    //MARK: - Actions
    
    
    @IBAction func testButtonAction(_ sender: UIBarButtonItem) {
        
        print("myWardrobe Contents: \n")
        
        if(myWardrobe.count != 0){
            
            for i in 1...myWardrobe.count {
                
                print(myWardrobe[i-1].color + " " + myWardrobe[i-1].type)
                
            }
            
            print("\n")
            
        }
        
        print("addedItemContents: \n")
        
        if(addedItems.count != 0){
            
            for y in 1...addedItems.count {
                
                print(addedItems[y-1].color + "" + addedItems[y-1].type)
                
            }
        }
        
    }
    
    
//---------------------------------------------------------------------------
    
    //MARK: - Table View Data Source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myWardrobe.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ClothingItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClothingItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ClothingItemTableViewCell.")
        }
        
        cell.textLabel?.text = myWardrobe[indexPath.row].color + " " + myWardrobe[indexPath.row].type
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myWardrobe.remove(at: indexPath.row)
            saveClothingItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    //  CREATING THE TABLE CELL
    
    /**
     
     public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     
     
     let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
     
     cell.textLabel?.text = myWardrobe[indexPath.row].color + " " + myWardrobe[indexPath.row].type
     
     
     return cell
     
     }*/

    
    
//---------------------------------------------------------------------------
    
    //MARK: Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new clothing item.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            
            guard let clothingItemDetailViewController = segue.destination as? ClothingItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedClothingItemCell = sender as? ClothingItemTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedClothingItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedClothingItem = myWardrobe[indexPath.row]
            clothingItemDetailViewController.clothingItem = selectedClothingItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
//---------------------------------------------------------------------------
    
    //MARK: - Actions
    
    @IBAction func unwindToMyWardrobe(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.source as? ClothingItemViewController, let clothingItem = sourceViewController.clothingItem {
            
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("updating clothing item")
                
                
                
                // Update an existing clothing item.
                
                myWardrobe[selectedIndexPath.row] = clothingItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                addedItems.removeAll()
                
            }else {
                // Add a new clothing item.
                
                
                for _ in 1...addedItems.count{
                    
                    let newIndexPath = IndexPath(row: myWardrobe.count, section: 0)
                    
                    myWardrobe.append(addedItems[0])
                    
                    addedItems.remove(at: 0)
                    
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    
                }
                
            }
            
            // Save the clothing items
            saveClothingItems()
            
            
            print(myWardrobe.count)
        }
    }
    

//---------------------------------------------------------------------------
    
    //MARK: Private Methods
    

    private func saveClothingItems() {
     
           /**
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myWardrobe, toFile: ClothingItem.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Clothing items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save clothing items...", log: OSLog.default, type: .error)
        }
        */
    }
    
    
    
    /*
    private func loadClothingItems() -> [ClothingItem]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ClothingItem.ArchiveURL.path) as? [ClothingItem]
    }
 */
 
    
}
