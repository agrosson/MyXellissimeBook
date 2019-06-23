//
//  LoanConfirmationViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 23/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import  Firebase

// MARK: - Class LoanConfirmationViewController
/**
 This class enables to confirm and save a book loan
 */
class LoanConfirmationViewController: UIViewController {

    var bookToLend = Book()
    var userBorrower = User()
    var fromDate: String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd.MM.yyyy"
        let date = Date()
        let stringOfDate = dateFormate.string(from: date)
        return stringOfDate
    }
    var toDate: String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd.MM.yyyy"
        let today = Date()
        let toDate = Calendar.current.date(byAdding: .day, value: 21, to: today)!
        let stringOfDate = dateFormate.string(from: toDate)
        return stringOfDate
    }
    let heightOfText: CGFloat = 20
    
    /*******************************************************
     UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// Title label for the book
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Author label for the book
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Container View for the book details
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// SeparateView
    let separateView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Container data Loan details
    let containerDataView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Reminder label
    let reminderLabel: UILabel = {
        let label = UILabel()
        label.text = "You want to lend this book to"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Reminder label
    let borrowerLabel: UILabel = {
        let label = UILabel()
        label.text = "name and email"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Reminder label
    let fromDateLabel: UILabel = {
        let label = UILabel()
        label.text = "From date: " // calculate now
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Reminder label
    let toDateLabel: UILabel = {
        let label = UILabel()
        label.text = "To date: " // calculate now
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // create button
    /// Confirmation button for loan
    lazy var confirmLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(confirmLoan), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        view.addSubview(containerDataView)
        containerDataView.addSubview(reminderLabel)
        containerDataView.addSubview(borrowerLabel)
        containerDataView.addSubview(fromDateLabel)
        containerDataView.addSubview(toDateLabel)
        containerDataView.addSubview(confirmLoanButton)
        setupScreen()
    }
    
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToLend.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupContainerView()
        setupSeparateView()
        setupContainerDataView()
        setupReminderLabel()
        setupBorrowerLabel()
        setupFromDateLabel()
        setupToDateLabel()
        setupConfirmLoanButton()
    }

    @objc func confirmLoan() {
        print("We will register loan here")
        
    }
    
    
    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
        let height:CGFloat = screenHeight/6
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10+topbarHeight).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        containerView.widthAnchor.constraint(equalTo : view.widthAnchor, constant: -20).isActive = true
    }
    
    /**
     Function that sets up bookCoverImageView
     */
    func setupBookCoverImageView(){
        // need x and y , width height contraints
        
        bookCoverImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: +20).isActive = true
        bookCoverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -30).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo:containerView.widthAnchor, constant: -3*screenWidth/4).isActive = true
    }
    /**
     Function that sets up titleLabel
     */
    func setupTitleLabel(){
        titleLabel.text = bookToLend.title
        // need x and y , width height contraints
        titleLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleLabel.rightAnchor.constraint(equalTo : containerView.rightAnchor, constant: -8).isActive = true
    }
    /**
     Function that sets up authorLabel
     */
    func setupAuthorLabel(){
        authorLabel.text = bookToLend.author
        // need x and y , width height contraints
        authorLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 15).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        authorLabel.rightAnchor.constraint(equalTo : containerView.rightAnchor, constant: -8).isActive = true
    }
    /**
     Function that sets up separateView
     */
    func setupSeparateView(){
        separateView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separateView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separateView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
    /**
     Function that sets up containerDataView
     */
    func setupContainerDataView(){
        // need x and y , width height contraints
        containerDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerDataView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        containerDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        containerDataView.widthAnchor.constraint(equalTo : view.widthAnchor, constant: -16).isActive = true
    }
    
    /**
     Function that sets up reminderLabel
     */
    func setupReminderLabel(){
        // need x and y , width height contraints
        reminderLabel.font = UIFont.systemFont(ofSize: heightOfText)
        reminderLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        reminderLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        reminderLabel.topAnchor.constraint(equalTo: containerDataView.topAnchor, constant: 10).isActive = true
        reminderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
       
    }
    /**
     Function that sets up borrower Label
     */
    func setupBorrowerLabel() {
        // need x and y , width height contraints
        borrowerLabel.font = UIFont.systemFont(ofSize: heightOfText)
        guard let name = userBorrower.name else {return}
        guard let email = userBorrower.email else {return}
        borrowerLabel.text = "\(name), with \(email)"
        borrowerLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        borrowerLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        borrowerLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 10).isActive = true
        borrowerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    /**
     Function that sets up fromDateLabel
     */
    func setupFromDateLabel() {
        // need x and y , width height contraints
        fromDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        fromDateLabel.text = "From: \(fromDate)"
        fromDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        fromDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        fromDateLabel.topAnchor.constraint(equalTo: borrowerLabel.bottomAnchor, constant: 10).isActive = true
        fromDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up toDateLabel
     */
    func setupToDateLabel() {
        // need x and y , width height contraints
        toDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        toDateLabel.text = "To: \(toDate)"
        toDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        toDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        toDateLabel.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor, constant: 10).isActive = true
        toDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up confirmLoanButton
     */
    func setupConfirmLoanButton() {
        // need x and y , width height contraints
        confirmLoanButton.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        confirmLoanButton.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        confirmLoanButton.bottomAnchor.constraint(equalTo: containerDataView.bottomAnchor, constant: -12).isActive = true
        confirmLoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
 
}
