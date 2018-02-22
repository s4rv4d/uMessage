//
//  MessageTableViewCell.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessageTableViewCell: UITableViewCell {

    //MARK:IBOutlets
    @IBOutlet weak var recievedMessageLabel:UILabel!
    @IBOutlet weak var recievedMsgView:UIView!
    @IBOutlet weak var sentMessageLabel:UILabel!
    @IBOutlet weak var sentMsgView:UIView!
    
    //MARK:Variables
    var message:Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message:Message){
        self.message = message
        
        print(message.sender)
        print("current is \(currentUser!)")
        
        if message.sender == currentUser{
            sentMsgView.isHidden = false
            sentMessageLabel.text = message.message
            print(sentMessageLabel.text as Any)
            print("if part")
            recievedMessageLabel.text = ""
            recievedMsgView.isHidden = true
            
        }else{
            sentMsgView.isHidden = true
            sentMessageLabel.text = ""
            recievedMessageLabel.text = message.message
            print(recievedMessageLabel.text as Any)
            print("else part")
            recievedMsgView.isHidden = false
        }
    }

}
