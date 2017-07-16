//
//  ClothingItemViewController.swift
//  styleUP
//
//  Created by Doğa Barsgan on 6/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  Screen where new clothing items are added or modified

import UIKit
import os.log

class ClothingItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    //  variables that are used to add to the wardrobe
    var typeSelected: String = ""
    var colorSelected: String = ""
    
    
    //  variables for the picker view
    var clothType = ["T-Shirt", "Pants",]
    var color = ["Black", "White",]
    
    // Wardrobe Page
    @IBOutlet weak var textBox1: UITextField!
    @IBOutlet weak var textBox2: UITextField!
    
    
    @IBOutlet weak var dropDown1: UIPickerView!
    @IBOutlet weak var dropDown2: UIPickerView!
    
    @IBOutlet weak var addToWard: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MyWardrobeViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new clothing item.
     */
    var clothingItem: ClothingItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing clothing item.
        if let clothingItem = clothingItem {
            
            
            updateButtonStates()
            addToWard.setTitle("UPDATE",for: .normal)
            navigationItem.title = clothingItem.type
            
            typeSelected = clothingItem.type
            colorSelected = clothingItem.color
            textBox1.text = clothingItem.type
            textBox2.text = clothingItem.color
            
        }
        
        updateButtonStates()
        
    }

    
//---------------------------------------------------------------------------
    
    //MARK: Actions

    @IBAction func actionSuccessful(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func addToWardTapped(_ sender: Any) {
        
        
        
        //  add the cloth struct to the list of structs
        
        let cloth = ClothingItem(type: typeSelected,color: colorSelected)
        
        
        if let cloth = clothingItem {
            
            clothingItem?.type = cloth.type
            clothingItem?.color = cloth.color
            
            
        } else {
            
            
            addedItems.append(cloth!)
            
        }
        
        
        if(!saveButton.isEnabled){
            
            saveButton.isEnabled = true;
            
        }
        
        
    }

    
//---------------------------------------------------------------------------
    
    //MARK: Private Methods
    
    private func updateButtonStates() {
        
        
        if(typeSelected != "" && colorSelected != "") {
            
            
            // enable the button
            
            addToWard.isEnabled = true;
            
            
        }
        
    }
    
    
//---------------------------------------------------------------------------
    
    //MARK: Picker View Functions
    
    
    //  Function that determines the number of colums of pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var countRows : Int = 0
        
        if (pickerView == dropDown1){
            
            countRows = self.clothType.count
            
        }
            
        else if (pickerView == dropDown2){
            
            countRows = self.color.count
            
        }
        
        return countRows
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView == dropDown1){
            
            let titleRow = clothType[row]
            
            return titleRow
            
        }
            
        else if (pickerView == dropDown2){
            
            let titleRow = color[row]
            
            return titleRow
            
        }
        
        return ""
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if(pickerView == dropDown1){
            
            self.textBox1.text = self.clothType[row]
            
            typeSelected = self.clothType[row]
            
            self.dropDown1.isHidden = true
            
            //  call add button enabler
            
            self.updateButtonStates()
            
            
        }
            
        else if (pickerView == dropDown2){
            
            self.textBox2.text = self.color[row]
            
            colorSelected = self.color[row]
            
            self.dropDown2.isHidden = true
            
            self.updateButtonStates()
            
            
        }
        
    }
    
    
//---------------------------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        
        if( textField == self.textBox1){
            
            //  disables keyboard
            textField.resignFirstResponder()
            
            self.dropDown1.isHidden = false
            
        } else if ( textField == self.textBox2) {
            
            //  disables keyboard
            textField.resignFirstResponder()
            
            self.dropDown2.isHidden = false
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonStates()
        navigationItem.title = textField.text
    }
    
//---------------------------------------------------------------------------
    
    
    //MARK: Navigation
    
    func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddClothingItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddClothingItemMode {
            addedItems.removeAll()
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            addedItems.removeAll()
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ClothingItemViewController is not inside a navigation controller.")
        }
    }
    
    
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
        //   INTEGRATE PICKER HERE
        
        let type = textBox1.text ?? ""
        let color = textBox2.text ?? ""
        
        
        // Set the clothing item to be passed to ClothingItemTableViewController after the unwind segue.
        clothingItem = ClothingItem(type: type, color: color)
    
        
    }
    
//---------------------------------------------------------------------------
    
}
