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

struct GlobVar {
    
    
    static var myWardrobe = [ClothingItem]()
    static var addedItems = [ClothingItem]()
    static var possibleCombs = [[ClothingItem]]()
    
    static var key = String()
    
}


class MyWardrobeViewController: UITableViewController{
//---------------------------------------------------------------------------


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItems = [editButtonItem, addButton, testButton]
        
        fetchMyWardrobe()
        
        //fetchPossibleCombinations()
        
        filterMyWardrobe()

        suggestClothing()

    }
    
 
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    

    @IBOutlet weak var testButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let ref = Database.database().reference()
    
    var userID = Auth.auth().currentUser?.uid


    
//---------------------------------------------------------------------------

    //MARK: - Actions
    
    @IBAction func unwindToMyWardrobe(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.source as? ClothingItemViewController, let clothingItem = sourceViewController.clothingItem {
            
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("updating clothing item")
                
                
                // Update an existing clothing item
                
                let otherClothingItem = GlobVar.myWardrobe[selectedIndexPath.row]
                
                GlobVar.myWardrobe[selectedIndexPath.row] = clothingItem
                
                updateClothingItem(id: otherClothingItem.id, color: clothingItem.color, type: clothingItem.type)

                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                
                GlobVar.addedItems.removeAll()
                
       
            } else {
                // Add a new clothing item.
                
                
                for item in GlobVar.addedItems{
                    
                    //let newIndexPath = IndexPath(row: GlobVar.myWardrobe.count, section: 0)
                    
                    addClothingItem(clothe: item)
                    
                    
                    //GlobVar.myWardrobe.append(GlobVar.addedItems[0])
                    
                    
                    
                    //tableView.insertRows(at: [newIndexPath], with: .automatic)
                    
                    
                }
                
                GlobVar.addedItems.removeAll()
                
            }
            
            
        }
    }

    
    
    @IBAction func testButtonAction(_ sender: UIBarButtonItem) {
        
        print("myWardrobe Contents: \n")
        
        if(GlobVar.myWardrobe.count != 0){
            
            for i in 1...GlobVar.myWardrobe.count {
                
                print(GlobVar.myWardrobe[i-1].color + " " + GlobVar.myWardrobe[i-1].type)
                
            }
            
            print("\n")
            
        }
        
        print("addedItem Contents: \n")
        
        if(GlobVar.addedItems.count != 0){
            
            for y in 1...GlobVar.addedItems.count {
                
                print(GlobVar.addedItems[y-1].color + "" + GlobVar.addedItems[y-1].type)
                
            }
        }
        
        print("possibleCombs Contents: \n")
        
        if(GlobVar.possibleCombs.count != 0){
            
            for y in 1...GlobVar.possibleCombs.count {
                
                print(GlobVar.possibleCombs[y-1][0].color + "" + GlobVar.possibleCombs[y-1][0].type)
                
                print(GlobVar.possibleCombs[y-1][1].color + "" + GlobVar.possibleCombs[y-1][1].type)

                
            }
        }

        
    }
    
    
    
    
//---------------------------------------------------------------------------
    
    //MARK: - Table View Data Source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return GlobVar.myWardrobe.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ClothingItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClothingItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ClothingItemTableViewCell.")
        }
        
        cell.textLabel?.text = GlobVar.myWardrobe[indexPath.row].color + " " + GlobVar.myWardrobe[indexPath.row].type
        
        
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
            
            deleteClothingItem(id: GlobVar.myWardrobe[indexPath.row].id)
            
            // Delete the row from the data source
            
            GlobVar.myWardrobe.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
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
            
            let selectedClothingItem = GlobVar.myWardrobe[indexPath.row]
            clothingItemDetailViewController.clothingItem = selectedClothingItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
//---------------------------------------------------------------------------
    
    //MARK: - Functions
    
    
    
    func fetchMyWardrobe() {
        
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        //observing the data changes
        ref.child("users").child(userID!).child("myWardrobe").observe(DataEventType.value, with: { (snapshot) in
            
            //clearing the list
            GlobVar.myWardrobe.removeAll()
            
            //reloading the tableview
            self.tableView.reloadData()

            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
            
                
                //iterating through the values
                for clothings in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let clothingObject = clothings.value as? [String: AnyObject]
                    
                    let clothingID = clothingObject?["id"] as! String
                    let clothingColor  = clothingObject?["color"] as! String
                    let clothingType = clothingObject?["type"] as! String
                    
                    //creating clothing object with model and fetched values
                    let clothe = ClothingItem(id: clothingID, type: clothingType,color: clothingColor)
                    
                    //appending it to list
                    GlobVar.myWardrobe.append(clothe!)
                }
                
                //reloading the tableview
                self.tableView.reloadData()
            }
            
           
        })
        
        
    }
    
    func addClothingItem(clothe: ClothingItem) {
        
        let key =  ref.child("users").child(userID!).child("myWardrobe").childByAutoId().key
        
        //  adding the clothe item as a dictionary
        
        let clothe = ["id": key, "color" : clothe.color , "type" : clothe.type ]
        
        ref.child("users").child(userID!).child("myWardrobe").child(key).setValue(clothe)
        
        
    }
    
    func deleteClothingItem(id: String) {
        
        
        ref.child("users").child(userID!).child("myWardrobe").child(id).setValue(nil)
        
    }
    
    func updateClothingItem(id: String, color: String, type: String) {
        
        // updating the clothe dictionary
        
        let clothe = ["id": id, "color" : color  ,"type": type]
        
        ref.child("users").child(userID!).child("myWardrobe").child(id).setValue(clothe)
        
    }
    
    
    //---------------------------------------------------------------------------
    
    
    func fetchPossibleCombinations() {
        
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        //observing the data changes
        ref.child("users").child(userID!).child("possibleCombs").observe(DataEventType.value, with: { (snapshot) in
            
            //clearing the list
            GlobVar.possibleCombs.removeAll()
            
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                var combination1 = [ClothingItem]()
                
                //iterating through the values
                for clothings in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let clothingObject = clothings.value as? [String: AnyObject]
                    
                    let clothingID = clothingObject?["id"] as! String
                    let clothingColor  = clothingObject?["color"] as! String
                    let clothingType = clothingObject?["type"] as! String
                    
                    //creating clothing object with model and fetched values
                    
                    let clothe = ClothingItem(id: clothingID, type: clothingType,color: clothingColor)
                    
                    
                    combination1.append(clothe!)
                    
                    //  SORUN BURADA !!!!
                    
                }
                
                //appending it to list
                GlobVar.possibleCombs.append(combination1)
                
                
            }
            
            
        })
        
        
    }
    
    func filterMyWardrobe() {
        
        
            
    
        
        //  creating the individual combination array MAKE THE NAME ADAPTIVE??
            
        var combination = [ClothingItem]()
    
        
        //observing the data changes
        ref.child("users").child(userID!).child("myWardrobe").observe(DataEventType.value, with: { (snapshot) in
            
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                
                
                //iterating through the values
                for clothings in snapshot.children.allObjects as! [DataSnapshot] {
                    
                                       
                    //getting values
                    let clothingObject = clothings.value as? [String: AnyObject]
                    
                    let clothingID = clothingObject?["id"] as! String
                    let clothingColor  = clothingObject?["color"] as! String
                    let clothingType = clothingObject?["type"] as! String
                    
                    
                    
                    
                    if(clothingColor == "White" && clothingType == "T-Shirt") {
                        
                         var upperPartClothingItem = ClothingItem(id: clothingID, type: clothingType, color: clothingColor)
                        
                        combination.append(upperPartClothingItem!)
                                               
                        
                    }
                    
                    if(clothingColor == "White" && clothingType == "Pants") {
                        
                        var lowerPartClothingItem = ClothingItem(id: clothingID, type: clothingType, color: clothingColor)
                        
                        combination.append(lowerPartClothingItem!)
            
                        
                    }
                    
                    
                }
                
                //  adding a combination into the possible combinations array
                
                GlobVar.possibleCombs.append(combination)
                

            }
            
            
        })
        
        
        //  adding each element of possibleCombs to the server one by one
        for item in GlobVar.possibleCombs{
            
            addClothingCombination(combinArray: item)
            
        }
        
        
        
        
    }
    
    func addClothingCombination(combinArray: [ClothingItem]) {
        
        let key =  ref.child("users").child(userID!).child("possibleCombs").childByAutoId().key
        
        //  adding the clothing combination as a dictionary
        
        
        if combinArray.count > 0 {
            
            
            
        
        let combArray = [
            
            ["id": key, "color" : combinArray[0].color , "type" : combinArray[0].type],
            ["id": key, "color" : combinArray[1].color , "type" : combinArray[1].type]
        
        ]
        
        ref.child("users").child(userID!).child("possibleCombs").child(key).setValue(combArray)
        
        }
    }
    
    func suggestClothing(){
        
        
       //   REPLACE UPPER IMAGE / LOWER IMAGE RANDOMLY FROM THE POSSIBLE COMBINATIONS ARRAY
        
        
    }   // FOR DISPLAY PURPOSES
    
    //---------------------------------------------------------------------------
    

    

//---------------------------------------------------------------------------
    
    //MARK: Private Methods
    

           /**
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myWardrobe, toFile: ClothingItem.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Clothing items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save clothing items...", log: OSLog.default, type: .error)
        }
        */
  
    
    
    
    /*
    private func loadClothingItems() -> [ClothingItem]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ClothingItem.ArchiveURL.path) as? [ClothingItem]
    }
 */
 
    
}
