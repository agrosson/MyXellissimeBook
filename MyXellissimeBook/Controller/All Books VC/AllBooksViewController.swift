//
//  AllBooksViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Class AllBooksViewController
/**
 This class defines the AllBooksViewController : lists the last books registered in database
 */

class AllBooksViewController: UITableViewController {
    
    // MARK: - Properties
    /// Id of cell of the tableView
    let cellId = "cellId"
    
    /// Array of user's books
    var allBooks = [Book]()
    
    var rootRef = DatabaseReference()
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "The last 20 books in database"

        tableView.register(UserBookCell.self, forCellReuseIdentifier: cellId)
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        rootRef.removeAllObservers()
    }
    
    // MARK: - Methods
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        allBooks.removeAll()
        tableView.reloadData()
        fetchBooks()
    }
    
    // MARK: - Method
    /**
     Function that fetches users in firebase database
     */
    private func fetchBooks(){
        rootRef = Database.database().reference()
        let query = rootRef.child(FirebaseUtilities.shared.books).queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
        query.observe(.value) { (snapshot) in
            // this to avoid duplicated row when reloaded
            self.allBooks = [Book]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let book = Book()
                    
                    let uniqueId = value["uniqueId"] as? String ?? "uniqueId not found"
                    let title = value["title"] as? String ?? "title not found"
                    let author = value["author"] as? String ?? "author not found"
                    let editor = value["editor"] as? String ?? "editor not found"
                    let isbn = value["isbn"] as? String ?? "isbn not found"
                    let isAvailable = value["isAvailable"] as? Bool ?? true
                    let coverURL = value["coverURL"] as? String ?? "coverURL not found"
                    let timestamp = value["timestamp"] as? Int ?? 0
                    
                    book.uniqueId = uniqueId
                    book.title = title
                    book.author = author
                    book.editor = editor
                    book.isbn = isbn
                    book.isAvailable = isAvailable
                    book.coverURL = coverURL
                    book.timestamp = timestamp

                    self.allBooks.append(book)
 
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    // todo : limit to 20 books
                }
            }
        }
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allBooks.reversed().count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserBookCell
       let book = allBooks.reversed()[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        cell.book  = book
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = allBooks.reversed()[indexPath.row]
        showSearchBookDetailViewControllerForBook(book: book)
        
        
    }
    /**
     Function that presents SearchBookDetailViewController
     */
    func showSearchBookDetailViewControllerForBook(book: Book){
        let searchBookDetailViewController = SearchBookDetailViewController()
        searchBookDetailViewController.bookToDisplay = book
        navigationController?.pushViewController(searchBookDetailViewController, animated: true)
    }
    
}
