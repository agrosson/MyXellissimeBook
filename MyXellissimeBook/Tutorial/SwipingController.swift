//
//  SwipingController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 18/10/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//
import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    /// Array of pages to display
    let pages = [
        Page(imageName: "firstPage",
             headerText: "Menu principal",
             bodyText: "- Accéder aux livres que vous proposez aux autres utilisateurs\n- Accéder aux livres que vous prêtez\n- Accéder aux livres que vous empruntez\n\nVous pouvez à tout moment naviguer dans l'application grâce aux boutons du menu du bas."),
        Page(imageName: "bookList",
             headerText: "Afficher la liste des livres que vous proposez",
             bodyText: "- Cliquer sur le livre pour avoir plus d'informations\n- Cliquer sur le bouton 'ajouter' pour ajouter un livre"),
        Page(imageName: "chatListOfUsers",
             headerText: "Afficher la liste des utilisateurs",
             bodyText: "Vous pouvez rechercher un utilisateur par son nom et cliquer sur son profil pour lui envoyer un message"),
    ]
    /// Button that enables to go to previous page of the tutorial
    private let previousButton = CustomUI().button
    /// Button that enables to go to next page of the tutorial
    private let nextButton = CustomUI().button
    /// Button that enables to skip the tutorial
    private let skipButton = CustomUI().button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomControls()
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
    }
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleSkip() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = mainBackgroundColor
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        previousButton.setTitle("Précédent", for: .normal)
        previousButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        previousButton.setTitleColor(mainBackgroundColor, for: .normal)
        previousButton.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        nextButton.setTitle("Suivant", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.setTitleColor(mainBackgroundColor, for: .normal)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        skipButton.setTitle("Fermer", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.backgroundColor = .yellow
        view.addSubviews(skipButton,bottomControlsStackView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
                skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
                skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
                skipButton.heightAnchor.constraint(equalToConstant: 50),
                bottomControlsStackView.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: 20),
                bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            NSLayoutConstraint.activate([
                skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
                skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
                skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
                skipButton.heightAnchor.constraint(equalToConstant: 50),
                bottomControlsStackView.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: 20),
                bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
}

extension SwipingController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }) { (_) in
        }
    }
}
extension SwipingController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
