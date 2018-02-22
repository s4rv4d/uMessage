//
//  File.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class Search{
    
    
    //MARK:Private variables
    private var _username:String!
    private var _userImg:String!
    private var _userKey:String!
    private var _userRef:DatabaseReference!
    
    //MARK:Variables
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var username:String{
        return _username
    }
    var userImg:String{
        return _userImg
    }
    var userKey:String{
        return _userKey
    }
    
    //MARK:Initialisers
    init(username:String,userImg:String) {
        _username = username
        _userImg = userImg
    }
    init(userKey:String,postData:Dictionary<String,AnyObject>) {
        _userKey = userKey
        if let username = postData["username"] as? String{
            _username = username
        }
        if let userImg = postData["userImg"] as? String{
            _userImg = userImg
        }
        _userRef = Database.database().reference().child("messages").child(_userKey)
    }
    
}
