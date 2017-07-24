//
//  AuthenticationScreen.swift
//  styleUP
//
//  Created by Doğa Barsgan on 7/18/17.
//  Copyright © 2017 Doğa Barsgan. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthenticationScreen: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let leftSwipe = UISwipeGestureRecognizer(target:self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target:self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }

    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBAction func changeButtonName(_ sender: Any) {
        
        if (segmentControl.selectedSegmentIndex == 0){
            
            loginButton.setTitle("Login", for: .normal)
            
        }else{
            
            
            loginButton.setTitle("Sign up", for: .normal)
            
        }
        
        
    }
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButton(_ sender: UIButton)  {
        
        
        if (emailText.text != "" && passwordText.text != ""){
            
            
            if(segmentControl.selectedSegmentIndex==0) { // sign-in
                
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user,error) in
                    
                    if user != nil {
                        
                        // Sign-in success!
                        
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                        
                    } else {
                        
                        if let myError = error?.localizedDescription {
                            
                            self.showSimpleAlert(title: "Error!", message: myError)
                            
                        }else {
                            
                            print("Error!")
                        }
                    }
                } )
                
                
            } else { //sign-up user
                
                
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user,error) in
                    
                    
                    if user != nil {
                        
                        // Sign-up success!
                        
                    } else {
                        
                        if let myError = error?.localizedDescription{
                            
                            print(myError)
                            
                            self.showSimpleAlert(title: "Error!", message: myError)
      
                        }else {
                            
                            print("Error!")
                        }
                    }
                })
                
            }
            
        }
        
    }
    
}

extension AuthenticationScreen{
    
    func swipeAction(swipe:UISwipeGestureRecognizer){
        
        switch swipe.direction.rawValue {
            
        case 1:
            // perform go left
            
            segmentControl.selectedSegmentIndex = 0
            changeButtonName(self)
            
            
        case 2:
            // perform go right
            
            segmentControl.selectedSegmentIndex = 1
            changeButtonName(self)
            
        default:
            break
            
            
        }
        
        
    }
    
    
    
}
