//
//  TableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Samuel Hyeman on 06/05/2020.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var meAvatorImage: UIImageView!
    @IBOutlet weak var youAvatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
