//
//  ChatTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Class ChatTableViewController
/**
 This class defines the ChatTableViewController : initial list of users
 */
class ChatTableViewController: UITableViewController {
    
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
            // this to avoid duplicated row when reloaded
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
        navigationItem.title = InitialViewController.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        cell.textLabel?.text = user.name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = user.email
        cell.detailTextLabel?.textColor = .white
        cell.imageView?.contentMode = .scaleAspectFill

        /*************************
         Reminder:
         Cell is of type UserCell
         Cell has a property profileImageView of type UIImageView
         Thanks to extension UIImageView, var profileImageView can use function loadingImageUsingCacheWithUrlString is set its (self).image to user profile photo
         **************************/
        if let userProfileImageURL = user.profileImageURL {
            cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: userProfileImageURL)
        }
        return cell
    }
    var chatInitial: ChatInitialViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("first step")
        dismiss(animated: true) {
             print("second step")
            let user = self.users[indexPath.row]
            self.chatInitial?.showChatControllerForUser(user: user)
        }
    }
}
