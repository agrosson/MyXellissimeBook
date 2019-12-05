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
    /// Array of filtered users used for searchBar
    var filteredUsers = [User]()
    /// Var that track the reference of the database
    var rootRef = DatabaseReference()
    /// Reference to ChatInitialViewController
    var chatInitial: ChatInitialViewController?
    /// searchBar
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Entrer le nom d'un contact"
        sb.delegate = self
        return sb
    }()
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.addSubview(searchBar)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        navigationController?.navigationBar.addSubview(searchBar)
        setupSearchBar()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        fetchUsers()
        rootRef.removeAllObservers()
    }
    // MARK: - Methods
    /**
    Function that setups searchBar
    */
    func setupSearchBar(){
        guard let navBar = navigationController?.navigationBar else {return
        }
        NSLayoutConstraint.activate([
            searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -8),
            searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: screenWidth/4),
            searchBar.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -12)
        ])
    }
    /**
     Function that fetches users in firebase database
     */
    private func fetchUsers(){
        rootRef = Database.database().reference()
        let query = rootRef.child(FirebaseUtilities.shared.users).queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            // this to avoid duplicated row when reloaded
            self.users = [User]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    let profileId = value["profileId"] as? String ?? "profileId not found"
                    let area = value["area"] as? String ?? "Région non renseignée"
                    user.name = name
                    user.email = email
                    user.profileId = profileId
                    user.area = area
                    self.users.append(user)
                }
            }
            self.users.sort{ $0.name!.lowercased() < $1.name!.lowercased() }
            self.filteredUsers = self.users
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    /**
        Function that setups screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    /**
       Function that handle cancel button
    */
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredUsers.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return typeOfDevice == "large" ? 120:80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let user = filteredUsers[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        cell.textLabel?.text = user.name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = user.email
        cell.detailTextLabel?.textColor = .white
        let area = user.area ?? "Région non renseignée"
        cell.timeLabelDate.text = "📍 \(area.localizedCapitalized)"
        cell.imageView?.contentMode = .scaleAspectFill

        /*************************
         Reminder:
         Cell is of type UserCell
         Cell has a property profileImageView of type UIImageView
         Thanks to extension UIImageView, var profileImageView can use function loadingImageUsingCacheWithUrlString is set its (self).image to user profile photo
         **************************/
        if let userprofileId = user.profileId {
            cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: userprofileId)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.filteredUsers[indexPath.row]
            self.chatInitial?.showChatControllerForUser(user: user)
        }
    }
}
extension ChatTableViewController: UISearchBarDelegate {
    /**
    Function that handles cancel button
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if filteredUsers.isEmpty || searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter({ user -> Bool in
                return (user.name?.localizedCaseInsensitiveContains(searchText))!
            })
        }
        self.tableView.reloadData()
    }
}
