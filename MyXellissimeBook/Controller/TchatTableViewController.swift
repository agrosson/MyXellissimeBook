//
//  TchatTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Class TchatTableViewController
/**
 This class defines the TchatTableViewController : initial list of users
 */
class TchatTableViewController: UITableViewController {
    
    // MARK: - Properties
    /// Identifier of the cell
    let cellId = "cellId"
    /// Array of users
    var users = [User]()
    /// Var that track the reference of the database
    var rootRef = DatabaseReference()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handelCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        fetchUsers()
        rootRef.removeAllObservers()
    }
    // MARK: - Method
    /**
     Function that fetches users in firebase database
     */
    private func fetchUsers(){
        rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            self.users = [User]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    let profileImageURL = value["profileImageURL"] as? String ?? "profileImageURL not found"
                    user.name = name
                    user.email = email
                    user.profileImageURL = profileImageURL
                    print(user.name as Any, user.email as Any, user.profileImageURL as Any)
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    
    /**
        Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
         guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                self.navigationItem.title = dictionary["name"] as? String
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
    }
    
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let user = users[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        cell.textLabel?.text = user.name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = user.email
        cell.detailTextLabel?.textColor = .white
      //  cell.imageView?.image = UIImage(named: "profileDefault")
        cell.imageView?.contentMode = .scaleAspectFill

        if let userProfileImageURL = user.profileImageURL {
            var download:StorageDownloadTask!
            print("let's download")
            let storageRef = Storage.storage().reference().child("profileImage").child("\(userProfileImageURL).jpg")
            DispatchQueue.main.async {
                print("let's be inside")
                download = storageRef.getData(maxSize: 1024*1024*5, completion:  { (data, error) in
                    print("let's be inside download")
                    guard let data = data else {
                        print("no data here")
                        return
                    }
                    if error != nil {
                        print("error here : \(error.debugDescription)")
                    }
                    print("download succeeded !")
                 //   cell.imageView?.image = UIImage(data: data)
                    download.resume()
                })
            }
        }
        return cell
    }
}
