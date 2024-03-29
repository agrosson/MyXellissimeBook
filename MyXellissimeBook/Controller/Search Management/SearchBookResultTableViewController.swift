//
//  SearchBookResultTableViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class SearchBookResultTableViewController
/**
 This class defines the SearchBookResultTableViewController
 
 This will display list of books depending on search attributes
 */
class SearchBookResultTableViewController: UITableViewController {

    // MARK: - Properties
    /// Id of cell of the tableView
    let cellId = "cellId"
    
    /// Array of user's books
    var books = [Book]()
    /// Title researched
    var titleSearch: String?
     /// author researched
    var authorSearch: String?
     /// isbn researched
    var isbnSearch: String?
    /// email researched
    var email: String?
    /// area research
    var area: String?
    var areaTemp = "areaTemp"
    
    var rootRef = DatabaseReference()
    
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserBookCell.self, forCellReuseIdentifier: cellId)
        addRefreshControl()
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        rootRef.removeAllObservers()
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        books.removeAll()
        tableView.reloadData()
        observeSearchBooks()
    }
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
     function that observes all the books that match with research attributes
     */
    private func observeSearchBooks(){
        if let area = area {
            FirebaseUtilities.getUsersFromArea(area: area) { (users) in
                for user in users {
                    guard let profileId = user.profileId else {return}
                    let root = Database.database().reference().child(FirebaseUtilities.shared.user_books).child(profileId)
                    root.observe(.childAdded) { (snaphot) in
                        let bookId = snaphot.key
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
                            var counter = 0
                            for bookAlready in self.books {
                                if bookAlready.uniqueId == bookId {
                                     counter = counter + 1
                                }
                            }
                            if counter == 0 {
                                self.books.append(book)
                            }
                    })
                }
            }
        }
        }
        // get the userId if email is provided
        var userIdToGet = ""
        if let email = email {
            FirebaseUtilities.getUserFromEmail(email: email, callBack: { (user) in
                userIdToGet = user.profileId ?? ""
                self.rootRef = Database.database().reference()
                let query = self.rootRef.child(FirebaseUtilities.shared.books).queryOrdered(byChild: "title")
                // observe the node
                query.observe(.childAdded, with: { (snapshot) in
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
                        var isbnTemp = UUID().uuidString
                        var titleTemp = UUID().uuidString
                        var authorTemp = UUID().uuidString
                        var ownerTemp = UUID().uuidString
                        if self.titleSearch != nil {
                            titleTemp = self.titleSearch!
                        }
                        if self.isbnSearch != nil {
                            isbnTemp = self.isbnSearch!
                        }
                        if self.authorSearch != nil {
                            authorTemp = self.authorSearch!
                        }
                        if !userIdToGet.isEmpty {
                            ownerTemp = userIdToGet
                        }
                        if isbn.localizedCaseInsensitiveContains(isbnTemp) || title.localizedCaseInsensitiveContains(titleTemp) || author.localizedCaseInsensitiveContains(authorTemp) || uniqueId.localizedCaseInsensitiveContains(ownerTemp){
                                 var counter = 0
                                 for bookAlready in self.books {
                                     if bookAlready.uniqueId == bookId {
                                          counter = counter + 1
                                     }
                                 }
                                 if counter == 0 {
                                     self.books.append(book)
                                 }
                        }
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }, withCancel: nil)

                }, withCancel: nil)
            })
        } else {
            rootRef = Database.database().reference()
            let query = rootRef.child(FirebaseUtilities.shared.books).queryOrdered(byChild: "title")
            // observe the node
            query.observe(.childAdded, with: { (snapshot) in
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
                    
                    var isbnTemp = UUID().uuidString
                    var titleTemp = UUID().uuidString
                    var authorTemp = UUID().uuidString
                    
                    if self.titleSearch != nil {
                        titleTemp = self.titleSearch!
                    }
                    if self.isbnSearch != nil {
                        isbnTemp = self.isbnSearch!
                    }
                    if self.authorSearch != nil {
                        authorTemp = self.authorSearch!
                    }
                    
                    if isbn.localizedCaseInsensitiveContains(isbnTemp) || title.localizedCaseInsensitiveContains(titleTemp) || author.localizedCaseInsensitiveContains(authorTemp) {
                             self.books.append(book)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }, withCancel: nil)

            }, withCancel: nil)
        }
        

    }

    /**
     Function that presents SearchBookDetailViewController
     */
    func showSearchBookDetailViewControllerForBook(book: Book){
        let searchBookDetailViewController = SearchBookDetailViewController()
        searchBookDetailViewController.bookToDisplay = book
        navigationController?.pushViewController(searchBookDetailViewController, animated: true)
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
        showSearchBookDetailViewControllerForBook(book: book)
    }
    /**
     Function that sets height for the row
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return typeOfDevice == "large" ? 150:100
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
    

}

