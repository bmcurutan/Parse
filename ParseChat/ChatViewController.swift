//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Jen Aprahamian on 10/27/16.
//  Copyright © 2016 Jen Aprahamian. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.getParseMessages), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        let newMessage = PFObject(className: "MessageSF")
        newMessage["text"] = self.messageTextField.text
        newMessage.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("sent message: \(newMessage)")
            } else {
                // There was a problem, check error.description
                print("error: \(error)")
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let message = self.messages[indexPath.row] as PFObject
        print(message)
            cell.textLabel?.text = message.object(forKey: "text") as? String
        
        cell.textLabel?.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getParseMessages() {
        
        let query = PFQuery(className:"MessageSF")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                if let objects = objects {
                    self.messages = objects
                    self.tableView.reloadData()
                    /*for object in objects {
                        //print(object.object(forKey: "text"))
                    }*/
                }
            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }

    }
}
