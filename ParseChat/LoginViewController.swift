//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Jen Aprahamian on 10/27/16.
//  Copyright © 2016 Jen Aprahamian. All rights reserved.
//

import Parse
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButton(_ sender: AnyObject) {
        if !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) -> Void in
                if error == nil {
                    print("succesful")
                } else {
                    //print("error: \(error!.userInfo!)")
                    print("error: \(error)")
                    self.onError("Login error. \(error?.localizedDescription)")
                }
            }
        }
    }

    @IBAction func onSignUpButton(_ sender: AnyObject) {
        let user = PFUser()
        user.username = "myUsername"
        user.password = "myPassword"
        user.email = "email@example.com"
        // other fields can be set just like with PFObject
        user["phone"] = "415-392-0202"
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                // let errorString = error.userInfo["error"] as? NSString
                print("error: \(error)")
                self.onError("Sign up error. \(error.localizedDescription)")
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
    
    // MARK: - UIAlert
    
    // create a cancel action
    func onError(_ message: String) {
        alertController.message = message as String
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
        // optional code for what happens after the alert controller has finished presenting
        }
    }
}

