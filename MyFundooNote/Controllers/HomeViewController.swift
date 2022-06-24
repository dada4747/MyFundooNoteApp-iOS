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
    var notes           :[NoteModel]?    = []
    var filteredNotes   : [NoteModel]    = []
    var resultDb : [NoteItem]? = []
    
    let addNoteButton : UIButton = {
        let button                  = UIButton()
        button.layer.cornerRadius   = 10
        button.layer.masksToBounds  = true
        button.tintColor            = .label
        button.setWidth(width: 60)
        button.setHeight(height: 60)
        button.setBackgroundImage(ConstantImages.addImage, for: .normal)
        return button
    }()
    
   
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
  
        super.viewDidLoad()
       
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {             layout.delegate = self
        }
        fetchNotes()
        searchController.searchBar.placeholder  = ConstantPlaceholders.searchNotes
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        collectionView.dataSource               = self
        collectionView.delegate                 = self
        configureAddNoteButton()
//        DataPersistanceManager.shared.fetchFromDB { result in
//            switch result {
//            case .success(let result):
//                print(result.first?.title)
//                self.resultDb = result
//                print(self.resultDb)
////                self.notes?.append(result)
//            case.failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//        DataPersistanceManager.shared.deleteNoteFromDB(id: (resultDb?.first?.id)!) { r in
//            switch r {
//            case .success(let r):
//                print("*******************+++++++++********************")
//
//                print("delete successful")
//            case .failure(let err):
//
//                print(err)
//            }
//        
//        }
//        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }
    
    
    // MARK: - Configuration UI
    
    //MARK: - Methods
    func fetchNotes(){
        LoaderAnimator.sharedInstance.show()
        
        DispatchQueue.global(qos: .utility).async {
            
            FirebaseNotsService.shared.fetchNotes{ [weak self]notes in
                guard let self = self else { return }
                LoaderAnimator.sharedInstance.hide()
                if notes.count < 10 {
                    self.hasMoreNotes   = false
                } else {
                    self.hasMoreNotes   = true
                }
                self.notes              = notes
                
                DispatchQueue.main.async { self.collectionView?.reloadData() }
            }
            
        }
    }
    
    func fetchMoreNotes() {
        LoaderAnimator.sharedInstance.show()
        DispatchQueue.global(qos: .utility).async {

        FirebaseNotsService.shared.fetchMoreNotes { [weak self] notes in
            guard let self = self else { return }
            LoaderAnimator.sharedInstance.hide()
            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.notes?.append(contentsOf: notes)
            DispatchQueue.main.async { self.collectionView?.reloadData() }
        }
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
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredNotes.count
        } else {
            return notes!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyNoteCollectionViewCell.reuseID, for: indexPath) as! MyNoteCollectionViewCell
        var thisNote: NoteModel
        if isSearching {
            thisNote     = filteredNotes[indexPath.row]
        } else {
            thisNote     = notes![indexPath.row]
        }
        cell.descriptionLabel.text = thisNote.discription
        cell.titleLabel.text = thisNote.title
        return cell
    }
    
    
}
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc          = AddNoteViewController()
        let thisNote    = notes![indexPath.row]
        vc.note         = thisNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if( hasMoreNotes && indexPath.row == notes!.count-1  ) {
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


// MARK: - collectionviewdelegateflowlayout
extension HomeViewController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let note = notes?[indexPath.item] {
            let topPadding = CGFloat(5)
            let bottomPadding = CGFloat(5)
            let titleFont = UIFont.systemFont(ofSize: 23)
            let titleHeight = self.heightOfText(for: note.title, with: titleFont, width: width - 10 )
            let height = topPadding + titleHeight + topPadding + bottomPadding
            return height
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let note = notes?[indexPath.item] {
            let topPadding = CGFloat(5)
            let bottomPadding = CGFloat(5)
            let descFont = UIFont.systemFont(ofSize: 17)
            let descHeight = self.heightOfText(for: note.discription, with: descFont, width: width - 10)
            let height = topPadding + descHeight + topPadding + bottomPadding
            return height
        }
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfColumn number: CGFloat) -> CGFloat {
        if isListView {
            return 1
        } else {
            return 2
        }
    }
    
    func heightOfText(for text: String, with font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(1503)
        let textAtributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight),options: .usesLineFragmentOrigin,attributes: textAtributes, context: nil)
        return ceil(boundingRect.height)
    }
}

// MARK: - Extension ResultUpdating and Search bar delegate
extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText      = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching     = true
            filteredNotes.removeAll()
            for item in notes! {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.discription.lowercased().contains(searchText.lowercased()) == true {
                    filteredNotes.append(item)
                }
            }
        }
        else {
            isSearching     = false
            filteredNotes.removeAll()
            filteredNotes   = notes!
        }
        collectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredNotes.removeAll()
        collectionView?.reloadData()
    }
}
