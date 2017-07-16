//
//  HomeViewController.swift
//  styleUP
//
//  Created by Doğa Barsgan on 6/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  Home Screen of the Application

import UIKit
import os.log

class HomeViewController: UIViewController{
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    @IBOutlet weak var upperBodyImageView: UIImageView!
    @IBOutlet weak var lowerBodyImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
//---------------------------------------------------------------------------
    
    //MARK: Actions

    
    @IBAction func tshirtTapped(_ sender: Any) {
        
        print("tshirt Tapped")
        upperBodyImageView.image = UIImage(named: "tshirtBlue")
        
    }
    
    
    @IBAction func pantsTapped(_ sender: Any) {
        
        print("pants Tapped")
        lowerBodyImageView.image = UIImage(named: "pantsBlack")
        
    }
    
//---------------------------------------------------------------------------
    
}
