//
//  LoginViewController.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/19/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import iProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:IBOutlets
    @IBOutlet weak var emailTextfield:UITextField!
    @IBOutlet weak var passwordTextfield:UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
   
    
    //MARK:Variables
    
    var userUid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         iProgressHUD.sharedInstance().attachProgress(toView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let current = KeychainWrapper.standard.string(forKey: "uid"){
//            print("already logged in")
            print("currently\(current)")
            performSegue(withIdentifier: "toMessages", sender: nil)
        }
    }
    
    //MARK:IBActions
    @IBAction func signIn(_ sender :AnyObject){
        
        view.showProgress()
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil{
                    self.userUid = user?.uid
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    //print("uid set")
                    
                    self.view.dismissProgress()
                    self.performSegue(withIdentifier: "toMessages", sender: nil)
                }
                else{
                    self.view.dismissProgress()
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            })
        }
    }
    
    //MARK: Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp"{
            if let destinationVC = segue.destination as? signUpViewController{
                if userUid != nil{
                    destinationVC.userUid = userUid
                }
                if emailTextfield.text != nil{
                    destinationVC.emailId = emailTextfield.text
                }
                if passwordTextfield.text != nil{
                    destinationVC.password = passwordTextfield.text
                }
            }
        }
    }
    //MARK:Textfields methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case passwordTextfield: scrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)
            break
        case emailTextfield: scrollView.setContentOffset(CGPoint.init(x: 0, y: 140), animated: true)
            break
        default:
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
