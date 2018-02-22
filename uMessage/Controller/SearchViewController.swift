//
//  SearchViewController.swift
//  uMessage
//
//  Created by Sarvad shetty on 2/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Variables
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail:Search!
    var recipient:String!
    var messageId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        Database.database().reference().child("users").observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.searchDetail.removeAll()
                for data in snapshot{
                    if let postDict = data.value as? Dictionary<String,AnyObject>{
                        let key = data.key
                        print("key \(key)")
                        let post = Search(userKey: key, postData: postDict)
                        print("the data in search part is \(postDict)")
                        self.searchDetail.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MessageViewController{
            destinationVC.recipient = recipient
            destinationVC.messageId = messageId
        }
    }
    
    //MARK:Tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return filteredData.count
        }else{
        return searchDetail.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchData:Search!
        if isSearching{
            searchData = filteredData[indexPath.row]
        }else{
            searchData = searchDetail[indexPath.row]
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? SearchTableViewCell{
            cell.configCell(search: searchData)
            return cell
        }else{
            return SearchTableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching{
            recipient = filteredData[indexPath.row].userKey
            print("reci user key is \(recipient)")
        }else{
            recipient = searchDetail[indexPath.row].userKey
            print("reci user key is \(recipient)")
        }
        performSegue(withIdentifier: "toMessage", sender: nil)
    }
    
    //MARK:SearchBar functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }else{
            isSearching = true
            filteredData = searchDetail.filter({ $0.username == searchBar.text
            })
            tableView.reloadData()
        }
    }
    
    
    //MARK:IBActions
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
