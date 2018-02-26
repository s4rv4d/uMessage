//
//  MessageViewController.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/19/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    //MARK:Variables
    var recipient:String!
    var messageId:String!
    var messages = [Message]()
    var message:Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    //MARK:IBOutlets
    @IBOutlet weak var sendButton:UIButton!
    @IBOutlet weak var messageField:UITextField!
    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var userNameBoiii: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.bringSubview(toFront: self.messView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        if messageId != "" && messageId != nil{
            loadData()
        }
       //MARK:For keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
        
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //MARK:Tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        message = messages[indexPath.row]
        //print("thecurrent msg is\(message.messageKey)")
       // userNameBoiii.text = message.sender
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? MessageTableViewCell{
            cell.configCell(message: message)
            return cell
        }else{
            return MessageTableViewCell()
        }
    }
    
    //MARK:Functions
    func loadData(){
        Database.database().reference().child("users").child(recipient).observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject>{
                let username = data["username"]
                self.userNameBoiii.text = username as? String
            }
        }
        Database.database().reference().child("messages").child(messageId).observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.messages.removeAll()
                print(snapshot)
                for data in snapshot{
                    if let postDict = data.value as? Dictionary<String,AnyObject>{
                        let key = data.key
                        print(key)
                        let post = Message(messageKey: key, postData: postDict)
                        print(postDict)
                        self.messages.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    @objc func dismisKeyboard(){
        messageField.endEditing(true)
    }
    func moveToBottom(){
        if messages.count > 0{
            let indexPath = IndexPath(row: messages.count-1, section: 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func keyboardWillShow(notification:NSNotification){
        messView.transform = CGAffineTransform(translationX: 0, y: view.frame.origin.y - 256)
        
        view.layoutIfNeeded()
    }
    @objc func keyboardWillHide(notification:NSNotification){
        
        messView.transform = CGAffineTransform(translationX: 0, y: view.frame.origin.y )
        view.setNeedsLayout()
    }
    
    
    //MARK:IBActions
    @IBAction func sendPresssed(_ sender: Any) {
        dismisKeyboard()
        
        if messageField.text != nil && messageField.text != ""{
            if messageId == nil{
                let post:Dictionary<String,AnyObject> = ["message":messageField.text as AnyObject,"sender":currentUser! as AnyObject]
                let message:Dictionary<String,AnyObject> = ["lastMessage":messageField.text as AnyObject,"user":currentUser! as AnyObject]
                let userMessage:Dictionary<String,AnyObject> = ["lastMessage":messageField.text as AnyObject,"user":recipient as AnyObject]
                messageId = Database.database().reference().child("messages").childByAutoId().key
                //print("message id is \(messageId)")
                
                let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
                firebaseMessage.setValue(post)
                let recipientMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
                recipientMessage.setValue(message)
                let useRMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
                useRMessage.setValue(userMessage)
                
                loadData()
            }else if messageId != nil{
                let post:Dictionary<String,AnyObject> = ["message":messageField.text as AnyObject,"sender":currentUser! as AnyObject]
                let message:Dictionary<String,AnyObject> = ["lastMessage":messageField.text as AnyObject,"user":currentUser! as AnyObject]
                let userMessage:Dictionary<String,AnyObject> = ["lastMessage":messageField.text as AnyObject,"user":recipient as AnyObject]
               
                
                let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
                firebaseMessage.setValue(post)
                let recipientMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
                recipientMessage.setValue(message)
                let useRMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
                useRMessage.setValue(userMessage)
                
                loadData()
            }
            messageField.text = ""
        }
    
    }

    @IBAction func BackPressed(_ sender: UIButton) {
     //dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "goBackToChat", sender: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.resignFirstResponder()
        return true
    }
}
