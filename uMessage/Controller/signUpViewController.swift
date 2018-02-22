//
//  signUpViewController.swift
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

class signUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var signUpButton:UIButton!
    
    //MARK:Variables
    var userUid:String!
    var emailId:String!
    var password:String!
    var username:String!
    var imagePicker = UIImagePickerController()
    var imageSelected = false
    
    //MARK:Actions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImagePicker.image = image
            imageSelected = true
        }else{
            print("didnt select image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func setUser(url:String){
        let userData = ["username":username!,"userImg":url]
        KeychainWrapper.standard.set(self.userUid, forKey: "uid")
        let location = Database.database().reference().child("users").child(userUid)
        location.setValue(userData)
        view.dismissProgress()
        dismiss(animated: true, completion: nil)
        
    }
    func uploadImg(){
        if usernameTextfield.text == nil{
            signUpButton.isHidden = true
        }else{
            username = usernameTextfield.text
            signUpButton.isHidden = false
        }
        guard let image = userImagePicker.image, imageSelected == true else{
            print("image needs to be selected")
            let alert = UIAlertController(title: "select image", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "return", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2){
            let imageUid = NSUUID().uuidString
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            Storage.storage().reference().child("images/ + \(imageUid)").putData(imageData, metadata: metaData){(metadata,error) in
                
                if error != nil{
                    print("error uploading image")
                }else{
                    print("uploaded")
                    
                    let downloadedURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadedURL{
                        self.setUser(url:url)
                    }
                }
                
            }
            
        }
        
    }
    
    //MARK:Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            performSegue(withIdentifier: "toMessages", sender: nil)
        }
    }
  
    //MARK:IBActions
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createTapped(_ sender: Any) {
        view.showProgress()
        Firebase.Auth.auth().createUser(withEmail: emailId, password: password) { (user, error) in
            if error != nil{
                print("can't create a user")
            }else{
                if let user = user{
                    self.userUid = user.uid
                }
            }
            self.uploadImg()
        }
    }
    @IBAction func selectedImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    

}
