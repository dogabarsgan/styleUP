//
//  ClothingItem.swift
//  styleUP
//
//  Created by Doğa Barsgan on 7/15/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//
//  Individual Clothing Item Class

import UIKit
import os.log

class ClothingItem  { //NSObject, NSCoding
    
//---------------------------------------------------------------------------
    
    //MARK: Properties
    
    var id: String
    var type: String
    var color: String
    
    
//---------------------------------------------------------------------------
    
    //MARK: Types
    
    /**
    struct PropertyKey {
        
        static let type = "type"
        static let color = "color"
        
    }*/
    
//---------------------------------------------------------------------------
    /**
    //MARK: Path Archiving
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("myWardrobe")
 
 */
    
//---------------------------------------------------------------------------
    
    //MARK: Initialization
    
    init?(id: String, type: String, color: String) {
        
        
        // Type and color must not be empty
        
        guard !type.isEmpty && !color.isEmpty else {
            
            return nil
        }
        
        
        // Initialization should fail if there is no type of color defined
        if type.isEmpty || color.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.id = id
        self.type = type
        self.color = color
        
    }
    
//---------------------------------------------------------------------------
   
    
/**
    
    //MARK: NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        
        
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(color, forKey: PropertyKey.color)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The type is required. If we cannot decode a type string, the initializer should fail.
        guard let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String else {
            os_log("Unable to decode the name for a Clothing Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The color is required. If we cannot decode a color string, the initializer should fail.
        guard let color = aDecoder.decodeObject(forKey: PropertyKey.color) as? String else {
            os_log("Unable to decode the name for a Clothing Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(type: type, color: color)
        
    }
    
 */
//---------------------------------------------------------------------------
    
}
