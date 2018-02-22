//
//  MessageDetail.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/19/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageDetail{
    
    //MARK:Variables
    private var _recipient:String!
    private var _messageKey:String!
    private var _messageRef:DatabaseReference!
    private var _prevMsg:String!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient:String{
        return _recipient
    }
    
    var messageKey:String{
        return _messageKey
    }
    var messageRef:DatabaseReference{
        return _messageRef
    }
    var prevMsg:String{
        return _prevMsg
    }
    init(user:String) {
        _recipient = user
    }
    
    init(messageKey:String,messageData:Dictionary<String, AnyObject>) {
        _messageKey = messageKey
        
        if let recipient = messageData["user"] as? String{
            _recipient = recipient
        }
        _messageRef = Database.database().reference().child("messages").child(_messageKey)
        
        if let prevMsg = messageData["lastMessage"] as? String{
            _prevMsg = prevMsg
        }
    }
    
}
