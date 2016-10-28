//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Jen Aprahamian on 10/27/16.
//  Copyright © 2016 Jen Aprahamian. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageUrlField: UITextField!
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        getParseMessages()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.getParseMessages), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        let newMessage = PFObject(className: "MessageSF")
        newMessage["user"] = PFUser.current()
        newMessage["text"] = self.messageTextField.text
        newMessage["imageUrl"] = self.imageUrlField.text
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.message.numberOfLines = 0
        let message = self.messages[indexPath.row] as PFObject
        print(message)
            cell.message.text = message.object(forKey: "text") as? String
        let user = message.object(forKey: "user") as? PFUser
        if (user?.username) != nil {
            cell.messageSender.text = user?.username
        }
        else {
            cell.messageSender.text = user?.email
        }
        
        if message.object(forKey: "imageUrl") != nil {
            let imageRequest = NSURLRequest(url: URL(string: message.object(forKey: "imageUrl") as! String)!)
            
            cell.messageImage.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    cell.messageImage.image = image
                }
                }, failure: { (imageRequest, imageResponse, error) -> Void in
                    print("Error: \(error.localizedDescription)")
                }
            )
        }
        
        cell.message.sizeToFit()
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
        query.includeKey("user")
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
