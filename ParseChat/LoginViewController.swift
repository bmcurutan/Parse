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
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
}
