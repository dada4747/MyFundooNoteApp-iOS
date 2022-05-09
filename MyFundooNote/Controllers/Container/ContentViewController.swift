//
//  ContentViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit
import Firebase

class ContentViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    weak var delegate: SideMenuDelegate?
    
    var barButtonImage      : UIImage?  = UIImage(systemName: "line.horizontal.3")
    var profileButtonImage  : UIImage?  = UIImage(systemName: "person.circle")
    var gridViewButtonImage : UIImage?  = UIImage(systemName: "square.grid.2x2")
    var listViewButtonImage : UIImage?  = UIImage(systemName: "rectangle.grid.1x2")
    
    var searchController                = UISearchController(searchResultsController: nil)
    var hasMoreNotes                    = true
    var isLoading                       = false
    var isSearching                     = false
    var isListView                      = false
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        authenticateUser()
        configureView()
        configureSeachController()
        configureCollectionView()
    }
    func logout() {
        do {
            try  Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error in signing out ")
        }
    }
    // MARK: - Configure UI
    private func configureView() {
        let barButtonItem       = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(menuTapped))
        
        let profileButtonItem   = UIBarButtonItem(image: profileButtonImage, style: .plain, target: self, action: #selector(profileTapped))
        let gridViewButtonItem  = UIBarButtonItem(image: gridViewButtonImage, style: .plain, target: self, action: #selector(gridButtonTapped))
        
        navigationController?.navigationBar.tintColor           = .label
        navigationItem.setLeftBarButton(barButtonItem, animated: false)
        navigationItem.setRightBarButtonItems([profileButtonItem, gridViewButtonItem], animated: false)
        definesPresentationContext                               = true
        navigationItem.hidesSearchBarWhenScrolling               = false
        
    }
    func configureCollectionView() {
        collectionView           = UICollectionView(frame: .zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView!)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 10,
                              paddingLeft: 0,
                              paddingBottom: 10,
                              paddingRight: 0)
        collectionView.register(MyNoteCollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor  = .secondarySystemBackground
        collectionView.frame            = view.bounds
    }
    func configureSeachController() {
        searchController.loadViewIfNeeded()
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType                 = UIReturnKeyType.done
        searchController.searchBar.placeholder                   = "Search for Notes"
        searchController.searchBar.autocorrectionType            = .no
        searchController.hidesNavigationBarDuringPresentation    = false
        searchController.searchBar.backgroundColor               = .secondarySystemBackground
        searchController.searchBar.tintColor                     = .label
        navigationItem.titleView = searchController.searchBar
    }
    // MARK: - Methods
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("user is already login user id is \(Auth.auth().currentUser?.uid ?? "") ")
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - Handlers
    @objc private func menuTapped() {
        delegate?.menuButtonTapped()
    }
    
    @objc private func profileTapped() {
        DispatchQueue.main.async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            //        showLoader(true)
            FirebaseNotsService.shared.fetchuser(withUid: uid) { user in
                //            self.showLoader(false)
                let provc = ProfileViewController()
                provc.delegate = self
                provc.user = user
                provc.modalPresentationStyle  = .overFullScreen
                provc.modalTransitionStyle    = .crossDissolve
                self.present(provc, animated: true)
            }
        }
    }
    
    @objc private func gridButtonTapped() {
        if isListView {
            gridViewButtonImage = UIImage(systemName: "rectangle.grid.1x2")
            isListView  = false
        } else {
            gridViewButtonImage = UIImage(systemName: "square.grid.2x2")
            isListView  = true
        }
        let profileButtonItem   = UIBarButtonItem(image: profileButtonImage, style: .plain, target: self, action: #selector(profileTapped))
        let gridViewButtonItem  = UIBarButtonItem(image: gridViewButtonImage, style: .plain, target: self, action: #selector(gridButtonTapped))
        self.navigationItem.setRightBarButtonItems([profileButtonItem,gridViewButtonItem], animated: true)
        
        collectionView?.reloadData()
    }
}
extension ContentViewController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}
