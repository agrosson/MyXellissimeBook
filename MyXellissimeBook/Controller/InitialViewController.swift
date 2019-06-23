//
//  ViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase



// MARK: - Class InitialViewController
/**
 This class defines the InitialViewController
 */
class InitialViewController: UIViewController {
   
    static var titleName = ""
   
    // MARK: - Properties
    // create button
    /// Button to show list of user's books
    lazy var showUserBooksButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("My list of books", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(showUserBooks), for: .touchUpInside)
        return button
    }()
    
    // create button
    /// Button to show list of user's books that are lent
    lazy var showUserBooksLentButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Show my books lent", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(showUserLentBooks), for: .touchUpInside)
        return button
    }()
    // create button
    /// Button to show list of user's books that are lent
    lazy var showUserBooksBorrowedButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Show books I've borrowed", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.addTarget(self, action: #selector(showBooksUserBorrowed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
      
        setupScreen()
        checkIfUserIsAlreadyLoggedIn()
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        setupScreen()
    }
    // MARK: - Methods
    /**
     Function that checks if user already loggedin
     */
    fileprivate func checkIfUserIsAlreadyLoggedIn() {
        // check if user is already logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        fetchUserAndSetupNavBarTitle()
        view.addSubview(showUserBooksLentButton)
        view.addSubview(showUserBooksButton)
        view.addSubview(showUserBooksBorrowedButton)
        setupShowUserBooksLentButton()
        setupShowUserBooksButton()
        setupShowUserBooksBorrowedButton()
       

    }
    /**
     Function that sets up showUserBooksLentButton
     */
    private func setupShowUserBooksLentButton(){
        // need x and y , width height contraints
        showUserBooksLentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showUserBooksLentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        showUserBooksLentButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showUserBooksLentButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up showUserBooksButton
     */
    private func setupShowUserBooksButton(){
        // need x and y , width height contraints
        showUserBooksButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showUserBooksButton.bottomAnchor.constraint(equalTo: showUserBooksLentButton.topAnchor, constant: -25).isActive = true
        showUserBooksButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showUserBooksButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up showUserBooksBorrowedButton
     */
    private func setupShowUserBooksBorrowedButton(){
        // need x and y , width height contraints
        showUserBooksBorrowedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showUserBooksBorrowedButton.topAnchor.constraint(equalTo: showUserBooksLentButton.bottomAnchor, constant: 25).isActive = true
        showUserBooksBorrowedButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showUserBooksBorrowedButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets title for NavBar
     */
    func fetchUserAndSetupNavBarTitle(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child(FirebaseUtilities.shared.users).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                
                let user = User()
                
                guard let name = dictionary["name"] as? String else {return}
                guard let email = dictionary["email"] as? String else {return}
                guard let profileId = dictionary["profileId"] as? String else {return}
                
                user.name = name
                user.email = email
                user.profileId = profileId
                
                self.setupNavBarWithUser(user: user)
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
    }
    
    func setupNavBarWithUser(user: User){
      //  self.navigationItem.title = user.name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileUrl = user.profileId {
             profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileUrl)
        }

        containerView.addSubview(profileImageView)
        // Contraints X Y Width height
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
         containerView.addSubview(nameLabel)
        // Contraints X Y Width height
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        containerView.addSubview(nameLabel)
        self.navigationItem.titleView = titleView
        
        
    }
    
    // MARK: - Method  - Actions with objc functions
    /**
     Action that shows the loginviewcontroller when navigationItem.leftBarButtonItem pressed
     */
    @objc func handleLogout() {
        // Try to log out
        do {
            try Auth.auth().signOut()
             print("You are successfully logged out")
        }
        catch let logoutError {
            // todo: Alert to do
            print("error somewhere \(logoutError)")
        }
        // present LoginController
        let loginController = LoginController()
        loginController.initialViewController = self
        present(loginController, animated: true, completion: nil)
    }

    /**
     Action that shows the list of user's books when showUserBooksButton is clicked
     */
    @objc func showUserBooks() {
        let userBooksTableViewController = UINavigationController(rootViewController: UserBooksTableViewController())
        present(userBooksTableViewController, animated: true, completion: nil)
    }

    /**
     Action that shows the list of user's books which are lent when showUserBooksLentButton is clicked
     */
    @objc func showUserLentBooks() {
        // present listOfUserBooksLentViewController
        let userLentBooksTableViewController = UINavigationController(rootViewController: UserLentBooksTableViewController())
        present(userLentBooksTableViewController, animated: true, completion: nil)
        
    }
    /**
     Action that shows the list of books that user has borrowed when showUserBooksBorrowedButton is clicked
     */
    @objc func showBooksUserBorrowed() {
        print("You will see the list of books that user has borrowed")
        // present listOfUserBooksBorrowedViewController
        
    }
}
