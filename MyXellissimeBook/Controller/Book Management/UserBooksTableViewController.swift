//
//  UserBooksTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Class UserBooksTableViewController
/**
 This class defines the UserBooksTableViewController
 */
class UserBooksTableViewController: UITableViewController {
    
    // MARK: - Properties
    /// Id of cell of the tableView
    let cellId = "cellId"
    
    /// Array of user's books
    var books = [Book]()
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handelCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBook))
        tableView.register(UserBookCell.self, forCellReuseIdentifier: cellId)
        // MARK: - Table view data source
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        books.removeAll()
        tableView.reloadData()
        observeUserBooks()
        
    }
    /**
     function that observes all the user's books
     */
    private func observeUserBooks(){
        // get the Id of the user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        // get the ref of list of message for this uid
        let ref = Database.database().reference().child(FirebaseUtilities.shared.user_books).child(uid)
        // observe the node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let bookId = snapshot.key
            // get the reference of the message
            let booksReference = Database.database().reference().child(FirebaseUtilities.shared.books).child(bookId)
            print("référence en cours de visualisation \(bookId)")
            // observe the messages for this user
            booksReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let book = Book()
                guard let uniqueId = dictionary["uniqueId"] as? String else {return}
                guard let title =  dictionary["title"] as? String else {return}
                guard let author =  dictionary["author"] as? String else {return}
                guard let isbn =  dictionary["isbn"] as? String else {return}
                guard let isAvailable =  dictionary["isAvailable"] as? Bool else {return}
                guard let coverURL =  dictionary["coverURL"] as? String else {return}
                guard let editor =  dictionary["editor"] as? String else {return}
                
                book.uniqueId = uniqueId
                book.title = title
                book.author = author
                book.isbn = isbn
                book.isAvailable = isAvailable
                book.coverURL = coverURL
                book.editor = editor
                
                self.books.append(book)
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    // MARK: - Method  - Actions with objc functions
    /**
     Action that shows the AddBookViewController when navigationItem.leftBarButtonItem pressed
     */
    @objc func addBook() {
        print("You will add a book")
        // present addBookViewController
        let addBookViewController = UINavigationController(rootViewController: AddBookViewController())
        present(addBookViewController, animated: true, completion: nil)
    }
    /**
     Action that dismisses VC when "back" button clicked
     */
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
     Function that presents detailAvailableBookViewController
     */
    func showDetailAvailableBookViewControllerForBook(book: Book){
        let detailAvailableBookViewController = DetailAvailableBookViewController()
        detailAvailableBookViewController.bookToDisplay = book
        navigationController?.pushViewController(detailAvailableBookViewController, animated: true)
    }
    /**
     Function that presents detailAvailableBookViewController
     */
    func showDetailLentBookViewControllerForBook(book: Book){
        let detailLentBookViewController = DetailLentBookViewController()
        detailLentBookViewController.bookToDisplay = book
        navigationController?.pushViewController(detailLentBookViewController, animated: true)
    }
    
    // MARK: - Methods - override func tableView
    /*******************************************************
     override func tableView
     ********************************************************/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = books[indexPath.row]
        if book.isAvailable == true {
            showDetailAvailableBookViewControllerForBook(book: book)
        } else {
            showDetailLentBookViewControllerForBook(book: book)
        }
    
        
    }
    /**
     Function that sets height for the row
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserBookCell
        // Get the message from the Array
        // let message = messages[indexPath.row]
        let book = books[indexPath.row]
        
        cell.book  = book
        return cell
    }
    
    /**
     Function that presents detailAvailableBookViewController
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(self.books.count)
        if editingStyle == .delete {
            let book = self.books[indexPath.row]
            guard let bookIdToRemove = book.uniqueId else {return}
            let refToRemove = Database.database().reference().child(FirebaseUtilities.shared.books).child(bookIdToRemove)
            refToRemove.removeValue { (error, dataref) in
                if error != nil {
                    print("fail to delete book", error as Any)
                    return
                }
                self.books.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
               print("Book removed from books in firebase ")
               // self.setupScreen()
            }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let refBookToRemoveForUser = Database.database().reference().child(FirebaseUtilities.shared.user_books).child(uid).child(bookIdToRemove)
            refBookToRemoveForUser.removeValue { (error, dataRef) in
                if error != nil {
                    print("fail to delete book", error as Any)
                    return
                }
                print("Book removed from user-books in firebase")
            }
        }
    }
}
