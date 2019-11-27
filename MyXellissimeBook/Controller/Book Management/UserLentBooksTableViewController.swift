//
//  UserLentBooksTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Class UserLentBooksTableViewController
/**
 This class defines the UserLentBooksTableViewController
 */
class UserLentBooksTableViewController: UITableViewController {
    // MARK: - Properties
    /// Id of cell of the tableView
    let cellId = "cellId"
    /// Array of user's lent books
    var lentBooks = [Book]()
    
    
    var refreshController = UIRefreshControl()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationItemColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Mes livres prêtés"
        tableView.register(UserBookCell.self, forCellReuseIdentifier: cellId)
        addRefreshControl()
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    // MARK: - Methods
    /**
     Function that adds and defines refresh control for collection view
     */
    fileprivate func addRefreshControl() {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes )
        refreshController.tintColor = .white
        refreshController.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshController)
    }
    /**
    Function that refreshes table View
    */
    @objc func refresh() {
        print("refresh selected")
        tableView.reloadData()
        self.refreshController.endRefreshing()
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        lentBooks.removeAll()
        tableView.reloadData()
        observeUserLentBooks()
        perform(#selector(testIfNoLoans), with: nil, afterDelay: 2)
    }
    /**
     Displays alert to explain the user how to add books
     */
    @objc func testIfNoLoans() {
        if self.lentBooks.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noLoansForUSer
        }
    }
    /**
     function that observes all the user's lent books
     */
    private func observeUserLentBooks(){
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
                if book.isAvailable == false {
                     self.lentBooks.append(book)
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    /**
     Function that presents detailAvailableBookViewController
     */
    func showDetailLentBookViewControllerForBook(book: Book){
        let detailLentBookViewController = DetailLentBookViewController()
        detailLentBookViewController.bookToDisplay = book
        navigationController?.pushViewController(detailLentBookViewController, animated: true)
    }
    // MARK: - Methods  - Actions with objc functions
    /**
     Action that dismisses VC when "back" button clicked
     */
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Methods - override func tableView
    /*******************************************************
     override func tableView
     ********************************************************/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lentBooks.count
    }
    /**
     Function that sets height for the row
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = lentBooks[indexPath.row]
        showDetailLentBookViewControllerForBook(book: book)
    }/**
     Function that returns the cell for the row
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserBookCell
        // Get the message from the Array
        // let message = messages[indexPath.row]
        let book = lentBooks[indexPath.row]
        cell.book  = book
        return cell
    }
}
