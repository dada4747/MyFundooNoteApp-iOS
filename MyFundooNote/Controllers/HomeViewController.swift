//
//  HomeViewController.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import UIKit
import Firebase

class HomeViewController: ContentViewController {
    
    // MARK: - Variable Declaration
    var notes           :[NoteModel]    = []
    var filteredNotes   : [NoteModel]   = []
    
    let addNoteButton : UIButton = {
        let button                  = UIButton()
        button.layer.cornerRadius   = 10
        button.layer.masksToBounds  = true
        button.tintColor            = .label
        button.setWidth(width: 60)
        button.setHeight(height: 60)
        button.setBackgroundImage(UIImage(systemName: "plus.app.fill"),
                                  for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
        
        
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
        
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        collectionView.dataSource               = self
        collectionView.delegate                 = self
        collectionView.reloadData()
        configureAddNoteButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        
        
        collectionView.reloadData()
    }
    
    
    // MARK: - Configuration UI
    
    //MARK: - Methods
    func fetchNotes(){
        FirebaseNotsService.shared.fetchNotes{ notes in
            if notes.count < 10 {
                self.hasMoreNotes   = false
            } else {
                self.hasMoreNotes   = true
            }
            self.notes              = notes
            DispatchQueue.main.async { self.collectionView?.reloadData() }
            
            //                self.collectionView?.reloadData()
        }
    }
    
    func fetchMoreNotes() {
        FirebaseNotsService.shared.fetchMoreNotes { notes in
            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.notes.append(contentsOf: notes)
            DispatchQueue.main.async { self.collectionView?.reloadData() }
            
            //                self.collectionView?.reloadData()
        }
    }
    //    func fetchNotes(){
    //        FirebaseNotsService.shared.fetchNotes{ [weak self] notes in
    //            guard let self = self else { return }
    //            self.updateUI(with: notes)
    //        }
    //    }
    //
    //    func fetchMoreNotes() {
    //        FirebaseNotsService.shared.fetchMoreNotes {[weak self] notes in
    //            guard let self = self else { return }
    //            self.updateUI(with: notes)
    //        }
    //    }
    //
    //    func updateUI(with notes: [NoteModel]) {
    //        if notes.count < 10 {
    //            self.hasMoreNotes = false
    //        } else {
    //            self.hasMoreNotes = true
    //        }
    //        self.notes = notes
    ////        self.notes.append(contentsOf: notes)
    //        DispatchQueue.main.async { self.collectionView?.reloadData() }
    //    }
    
    func configureAddNoteButton() {
        view.addSubview(addNoteButton)
        addNoteButton.addTarget(self, action: #selector(addNoteAction), for: .touchUpInside)
        addNoteButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingRight: 30)
    }
    
    // MARK: - Handlers
    @objc func addNoteAction() {
        let addNoteVC = AddNoteViewController()
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

// MARK: - Data source and delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredNotes.count
        } else {
            return notes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        var thisNote: NoteModel
        if isSearching {
            thisNote     = filteredNotes[indexPath.row]
        } else {
            thisNote     = notes[indexPath.row]
        }
        cell.descriptionLabel.text = thisNote.desc
        cell.titleLabel.text = thisNote.title
        //        cell.note    = thisNote
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc          = AddNoteViewController()
        let thisNote    = notes[indexPath.row]
        vc.note         = thisNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if( hasMoreNotes && indexPath.row == notes.count-1  ) {
            fetchMoreNotes()
        } else {
            isLoading = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            
            return CGSize(width: collectionView.bounds.size.width, height: 60)
        }
        
        
    }
}

// MARK: - Extension ResultUpdating and Search bar delegate
extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText      = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching     = true
            filteredNotes.removeAll()
            for item in notes {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true {
                    filteredNotes.append(item)
                }
            }
        }
        else {
            isSearching     = false
            filteredNotes.removeAll()
            filteredNotes   = notes
        }
        collectionView?.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredNotes.removeAll()
        collectionView?.reloadData()
    }
}

// MARK: - collectionviewdelegateflowlayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let size = CGSize(width: bounds.width, height: 1000)
        let note = notes[indexPath.row]
        let titleFont = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 23)]
        let descFont  = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 17)]
        
        let estimatedFrameDesc = NSString(string: note.desc).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: descFont, context: nil)
        let estimatedFrameTitle = NSString(string: note.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: titleFont, context: nil)
        if !isListView {
            return CGSize(width: bounds.width/2 - 10   , height:  estimatedFrameTitle.height + estimatedFrameDesc.height + 20  )
        } else {
            return CGSize(width: bounds.width - 10 , height: estimatedFrameTitle.height + estimatedFrameDesc.height + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
