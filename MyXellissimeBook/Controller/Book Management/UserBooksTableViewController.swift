//
//  UserBooksTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

class UserBooksTableViewController: UITableViewController {
    
    /// Id of cell of the tableView
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBook))
          tableView.register(UserBookCell.self, forCellReuseIdentifier: cellId)
        // MARK: - Table view data source
        setupScreen()

    }
    
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
    }
    
    // MARK: - Method  - Actions with objc functions
    /**
     Action that shows the loginviewcontroller when navigationItem.leftBarButtonItem pressed
     */
    @objc func addBook() {
        print("You will add a book")
        // present addBookViewController
        let addBookViewController = UINavigationController(rootViewController: AddBookViewController())
        present(addBookViewController, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserBookCell
        // Get the message from the Array
       // let message = messages[indexPath.row]
        let book = Book()
        book.title = "book title"
        book.author = " book author"
        book.editor = "editor"
        book.isbn = "9780552565974"
        cell.book  = book
        book.isAvailable = false
        
        if let availability = book.isAvailable  {
            if availability {
                cell.availabilityImageView.image = #imageLiteral(resourceName: "greenButton")
            }
            else {
            cell.availabilityImageView.image = #imageLiteral(resourceName: "redButton")
            }
        }
    
        return cell
    }
}
