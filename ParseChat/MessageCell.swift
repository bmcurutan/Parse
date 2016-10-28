//
//  MessageCell.swift
//  ParseChat
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Jen Aprahamian. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageSender: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
