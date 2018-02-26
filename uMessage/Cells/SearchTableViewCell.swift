//
//  SearchTableViewCell.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SearchTableViewCell: UITableViewCell {

    //MARK:IBOutlets
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:Variables
    var searchDetail:Search!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(search:Search){
        self.searchDetail = search
        self.nameLabel.text = searchDetail.username
       // print("it is \(searchDetail.userImg)")
        let ref = Storage.storage().reference(forURL: searchDetail.userImg as String)
        ref.getData(maxSize: 100000000) { (data, error) in
            if error != nil{
                print("we couldnt upload the image")
            }else{
                
                if let imageData = data{
                    if let image = UIImage(data: imageData){
                        self.img.image = image
                    }
                }
            }
        }
        
    }

}
