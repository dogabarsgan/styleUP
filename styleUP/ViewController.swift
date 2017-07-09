//
//  ViewController.swift
//  styleUP
//
//  Created by Doğa Barsgan on 6/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//


import UIKit


//  clothing item struct that will be stored in the wardrobe
struct ClothingItem {
    
    var type: String
    
    var color: String
    
}


//  Initializing the myWardrobe array
var myWardrobe = [ClothingItem]()


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    
    //  variables that are used to add to the wardrobe
    var typeSelected: String = ""
    var colorSelected: String = ""
    
    
    //  variables for the picker view
    var clothType = ["T-Shirt", "Pants",]
    var color = ["Black", "White",]
    
    
    //  IB Outlets:
    
    //  Home Page
    @IBOutlet weak var upperBodyImageView: UIImageView!
    @IBOutlet weak var lowerBodyImageView: UIImageView!
    
    
    // Wardrobe Page
    @IBOutlet weak var textBox1: UITextField!
    @IBOutlet weak var textBox2: UITextField!
    
    
    @IBOutlet weak var dropDown1: UIPickerView!
    @IBOutlet weak var dropDown2: UIPickerView!
    
    
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    //  picker view functions
    
    
    //  function that determines the number of colums of pickerview
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
            
        }
            
        else if (pickerView == dropDown2){
            
            self.textBox2.text = self.color[row]
            
            colorSelected = self.color[row]
            
            self.dropDown2.isHidden = true
            
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
    
    
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    // IB Outlets for buttons
    
    @IBAction func tshirtTapped(_ sender: Any) {
        
        print("tshirt Tapped")
        upperBodyImageView.image = UIImage(named: "tshirtBlue")
        
    }
    
    
    @IBAction func pantsTapped(_ sender: Any) {
        
        print("pants Tapped")
        lowerBodyImageView.image = UIImage(named: "pantsBlack")
        
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        print("pants Tapped")
        
    }
    
    
    @IBAction func addToWardTapped(_ sender: Any) {
        
        //  add the cloth struct to the list of structs
        
        let cloth = ClothingItem(type: typeSelected,color: colorSelected)
        
        myWardrobe.append(cloth)
        
        print(myWardrobe.count)
        
        
        
    }
    
    
    //  button that prints the content of the wardrobe
    
    @IBAction func contentWardrobe(_ sender: Any) {
        
        for index in 1...myWardrobe.count {
            
            print(myWardrobe[index-1].type)
            print(myWardrobe[index-1].color)
            
        }
        
    }
    
    
    //  button that will show random combination of garment
    
    @IBAction func randomize(_ sender: Any) {
        
        //upperBodyImageView.image = UIImage(named: "tshirtBlue")
        
        //lowerBodyImageView.image = UIImage(named: "pantsBlack")
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    //  hiding keyboard when outside of keyboard is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    //  pressing return key to hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return(true)
    }
    
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
}
