//
//  Message.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Message{

    //MARK:Private variables
    private var _message:String!
    private var _sender:String!
    private var _messageKey:String!
    private var _messageRef:DatabaseReference!
    
    //MARK:Variables
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var message:String{
        return _message
    }
    var sender:String{
        return _sender
    }
    var messageKey:String{
        return _messageKey
    }
    
    //MARK:Initialisers
    init(message:String,sender:String) {
        _message = message
        _sender = sender
    }
    init(messageKey:String,postData:Dictionary<String,AnyObject>) {
        _messageKey = messageKey
        if let message = postData["message"] as? String{
            _message = message
        }
        if let sender = postData["sender"] as? String{
            _sender = sender
        }
        _messageRef = Database.database().reference().child("messages").child(_messageKey)
    }
    
}
