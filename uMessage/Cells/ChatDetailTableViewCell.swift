//
//  ChatDetailTableViewCell.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/19/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatDetailTableViewCell: UITableViewCell {
    
    //MARK:IBOutlets
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userIdLabel:UILabel!
    @IBOutlet weak var userMsgDescrip:UILabel!

    var messageDetail:MessageDetail!
    var userPostKey:DatabaseReference!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = 35
        userImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(messageDetail:MessageDetail){
        
        self.messageDetail = messageDetail
        
        let userData = Database.database().reference().child("users").child(messageDetail.recipient)
        userData.observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject>{
                let username = data["username"]
                let userImg = data["userImg"]
                
                self.userIdLabel.text = username as? String
                self.userMsgDescrip.text = messageDetail.prevMsg
                
                let ref = Storage.storage().reference(forURL: userImg as! String)
                ref.getData(maxSize: 100000, completion: { (data, error) in
                    if error != nil{
                        print("error loading image")
                    }
                    if let imageData = data{
                        if let image = UIImage(data: imageData){
                            self.userImage.image = image
                        }
                    }
                })
                
            }
        }
        
    }

}
