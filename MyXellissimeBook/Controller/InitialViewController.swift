//
//  ViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import CoreLocation



// MARK: - Class InitialViewController
/**
 This class defines the InitialViewController
 */
class InitialViewController: UIViewController {
    
    static var titleName = ""
    
    // MARK: - Properties
    /// Button to show list of user's books
    lazy var showUserBooksButton = CustomUI().button
    /// Button to show list of user's books that are lent
    lazy var showUserBooksLentButton = CustomUI().button
    /// Button to show list of user's books that are lent
    lazy var showUserBooksBorrowedButton = CustomUI().button
    /// View to display adds
    var advertisingBannerView = GADBannerView()

    let locationManager = CLLocationManager()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Déconnexion", style: .plain, target: self, action: #selector(handleConnexion))
        checkIfUserIsAlreadyLoggedIn()
        setupScreen()
        setupBanner()
        updateUserLocation()
        
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        setupScreen()
        perform(#selector(testIfNewMessage), with: nil, afterDelay: 2)
        UIApplication.shared.applicationIconBadgeNumber = 0
        updateUserLocationInFirebase()
    }
    // MARK: - Methods
    /**
     Function that setups advertissing banner
     */
    private func setupBanner(){
        // Banner
        //real adUnitID for banner
        //advertisingBannerView.adUnitID = "ca-app-pub-9970351873403667/5083216814"
        // test id for banner
        advertisingBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        advertisingBannerView.rootViewController = self
        advertisingBannerView.load(GADRequest())
        advertisingBannerView.delegate = self
    }
    /**
    Function that check if a message has been sent to current user while logged out
    */
    @objc func testIfNewMessage(){
        if newMessage {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .newMessagesAfterLogin
        }
    }
    /**
     Function that checks if user already loggedin
     */
    func checkIfUserIsAlreadyLoggedIn() {
        // check if user is already logged in
        if Auth.auth().currentUser?.uid == nil {
            print("no current")
            perform(#selector(handleLogout), with: nil, afterDelay: 0.1)
        }
    }
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        fetchUserAndSetupNavBarTitle()
        view.addSubviews(showUserBooksLentButton,showUserBooksButton,showUserBooksBorrowedButton,advertisingBannerView)
        setupShowUserBooksLentButton()
        setupShowUserBooksButton()
        setupShowUserBooksBorrowedButton()
        setupBannerView()
    }
    /**
     Function that sets up showUserBooksLentButton
     */
    private func setupShowUserBooksLentButton(){
        showUserBooksLentButton.setTitle("Mes livres prêtés", for: .normal)
        showUserBooksLentButton.layer.cornerRadius = 15
        showUserBooksLentButton.titleLabel?.font = .systemFont(ofSize: 25)
        showUserBooksLentButton.addTarget(self, action: #selector(showUserLentBooks), for: .touchUpInside)
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
        showUserBooksButton.setTitle("Ma liste de livres", for: .normal)
        showUserBooksButton.layer.cornerRadius = 15
        showUserBooksButton.titleLabel?.font = .systemFont(ofSize: 25)
        showUserBooksButton.addTarget(self, action: #selector(showUserBooks), for: .touchUpInside)
        
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
        
        showUserBooksBorrowedButton.setTitle("Mes livres empruntés", for: .normal)
        showUserBooksBorrowedButton.layer.cornerRadius = 15
        showUserBooksBorrowedButton.titleLabel?.font = .systemFont(ofSize: 25)
        showUserBooksBorrowedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showUserBooksBorrowedButton.titleLabel?.minimumScaleFactor = 0.5
        showUserBooksBorrowedButton.addTarget(self, action: #selector(showBooksUserBorrowed), for: .touchUpInside)
        // need x and y , width height contraints
        showUserBooksBorrowedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showUserBooksBorrowedButton.topAnchor.constraint(equalTo: showUserBooksLentButton.bottomAnchor, constant: 25).isActive = true
        showUserBooksBorrowedButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showUserBooksBorrowedButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    private func setupBannerView(){
        advertisingBannerView.translatesAutoresizingMaskIntoConstraints = false
        // need x and y , width height contraints
        advertisingBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            advertisingBannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
           advertisingBannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        }
        advertisingBannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        advertisingBannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
    }
    /**
     Function that sets title for NavBar
     */
    func fetchUserAndSetupNavBarTitle(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //   navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Connexion", style: .plain, target: self, action: #selector(handleConnexion))
            return}
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
    @objc func handleConnexion() {
        if Auth.auth().currentUser?.uid != nil &&   navigationItem.leftBarButtonItem?.title == "Déconnexion" {
            let actionSheet = UIAlertController(title: "Cher Utilisateur", message: "Vous voulez vraiment vous déconnecter?", preferredStyle: .alert)
            
            actionSheet.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction) in
                self.handleLogout()
            }))
            actionSheet.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion : nil)
        }
        
    }
    /**
     Action that shows the loginviewcontroller when navigationItem.leftBarButtonItem pressed
     */
    @objc func handleLogout() {
        if let uid = Auth.auth().currentUser?.uid
        {
            FirebaseUtilities.changeToken(uid: uid)
        }
        
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
        // present listOfUserBooksLentViewController
        let userBorrowedBooksTableViewController = UINavigationController(rootViewController: UserBorrowedBooksTableViewController())
        present(userBorrowedBooksTableViewController, animated: true, completion: nil)
    }
}

extension InitialViewController: GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

extension InitialViewController {
    
    private func updateUserLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }
    private func updateUserLocationInFirebase(){
        if let location = locationManager.location?.coordinate {
            let latitude = location.latitude
            let longitude = location.longitude
            if let uid = Auth.auth().currentUser?.uid {
                FirebaseUtilities.updateUserLocation(latitude: latitude,longitude: longitude,userUid: uid)
            }
        }
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            updateUserLocationInFirebase()
            break
        case .denied:
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .locationAuthorization
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .locationAuthorization
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
}


extension InitialViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
    
}
