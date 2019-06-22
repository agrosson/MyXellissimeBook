//
//  DetailLentBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class DetailLentBookViewController: UIViewController {

    var bookToDisplay: Book?
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let loanDetailsLabelHeight:CGFloat = {
        if UIScreen.main.bounds.height > 700 {
            return 60
        }
        return 40}()
    
    let loanTextSize: CGFloat = 22
    let insetBetweenLabels: CGFloat = 20

    /*******************************************************
     UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// Title label for the book
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
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
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Editor label for the book
    let editorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Container View for Loan details
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Borrower label for the lent book
    let borrowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Starting date for the lent
    let startingDateOfLoanLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Expected end date for the lent
    let expectedEndDateOfLoanLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // create button
    /// Modify loan Button
    lazy var modifyLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Modify", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleModifyLoan), for: .touchUpInside)
        return button
    }()
    // create button
    /// Close loan Button
    lazy var closeLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleCloseLoan), for: .touchUpInside)
        return button
    }()

    /*******************************************************
     UI variables: End
     ********************************************************/
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screenHeight)
        view.addSubview(bookCoverImageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(editorLabel)
        view.addSubview(containerView)
        containerView.addSubview(borrowerLabel)
        containerView.addSubview(startingDateOfLoanLabel)
        containerView.addSubview(expectedEndDateOfLoanLabel)
        containerView.addSubview(modifyLoanButton)
        containerView.addSubview(closeLoanButton)
        setupScreen()
    }
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToDisplay?.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupEditorLabel()
        setupContainerView()
        setupBorrowerLabel()
        setupStartingDateOfLoanLabel()
        setupExpectedEndDateOfLoanLabel()
        setupModifyLoanButton()
        setupCloseLoanButton()
    }
    
    @objc func handleModifyLoan(){
        print("will lead to screen to modify the loan")
    }
    @objc func handleCloseLoan(){
        print("will lead to the loan")
    }
}
