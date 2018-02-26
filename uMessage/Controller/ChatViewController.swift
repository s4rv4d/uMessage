//
//  ChatViewController.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/19/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import iProgressHUD

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK:IBOutlets
    @IBOutlet weak var tableview:UITableView!
    
    //MARK:Variables
    var messageDetail = [MessageDetail]()
    var detail:MessageDetail!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient:String!
    var messageId:String!
    var testPassUserName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("for chat view")
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                print(snapshot)
                
                self.messageDetail.removeAll()
                for data in snapshot{
                    if let messageDict = data.value as? Dictionary<String,AnyObject>{
                        let key = data.key
                        //print("key is \(key)")
                        let info  = MessageDetail(messageKey: key, messageData: messageDict)
                        //print("dict is \(messageDict)")
                        self.messageDetail.append(info)
                    }
                }
            }
            self.tableview.reloadData()
            
        }
        tableview.separatorStyle = .singleLine
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
         iProgressHUD.sharedInstance().attachProgress(toView: self.view)
    
    }

    
    //MARK:TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let message = messageDetail[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatDetailTableViewCell
        
        cell?.configureCell(messageDetail: message)
          // print("dskdk \(testPassUserName)")
        return cell!
            
    
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = messageDetail[indexPath.row].recipient
        messageId = messageDetail[indexPath.row].messageRef.key
        performSegue(withIdentifier: "toMessage", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.recipient = recipient
            destination.messageId = messageId
//            destination.userNameBoiii.text = testPassUserName
        }
    }
    
    //MARK:IBActions
    @IBAction func signOut(_ sender:AnyObject){
        try! Auth.auth().signOut()
        KeychainWrapper.standard.removeObject(forKey: "uid")
        print("removed uid")
        dismiss(animated: true, completion: nil)
    }
}
