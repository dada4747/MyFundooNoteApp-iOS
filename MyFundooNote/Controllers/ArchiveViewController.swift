//
//  ArchiveViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

class ArchiveViewController: ContentViewController {
    
    // MARK: - Variabels
    var archiveNotes :[NoteModel]           = []
    var filteredNotes:[NoteModel]           = []
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArchiveNotes()
        view.backgroundColor = .secondarySystemBackground
        collectionView?.reloadData()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Search Archives"
        collectionView.dataSource              = self
        collectionView.delegate                = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArchiveNotes()
        collectionView.reloadData()
    }
    
    // MARK: - Configure ui
    
    // MARK: - Functions
    func fetchArchiveNotes() {
        FirebaseNotsService.shared.fetchArchive { notes in
            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.archiveNotes       = notes
            self.collectionView?.reloadData()
        }
    }
    
    func fetchMoreArchiveNotes() {
        FirebaseNotsService.shared.fetchMoreArchive { notes in
            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.archiveNotes.append(contentsOf: notes)
            self.collectionView?.reloadData()
        }
    }
}


// MARK: - Data source and delegate
extension ArchiveViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredNotes.count
        } else {
            return archiveNotes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        var thisNote: NoteModel
        if isSearching {
            thisNote     = filteredNotes[indexPath.row]
        } else {
            thisNote     = archiveNotes[indexPath.row]
        }
        cell.descriptionLabel.text = thisNote.desc
        cell.titleLabel.text = thisNote.title
        //        cell.note    = thisNote
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc          = AddNoteViewController()
        let thisNote    = archiveNotes[indexPath.row]
        vc.note         = thisNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(hasMoreNotes)
        if( hasMoreNotes && indexPath.row == archiveNotes.count-1  ) {
            fetchMoreArchiveNotes()
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
extension ArchiveViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText      = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching     = true
            filteredNotes.removeAll()
            for item in archiveNotes {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true {
                    filteredNotes.append(item)
                }
            }
        }
        else {
            isSearching     = false
            filteredNotes.removeAll()
            filteredNotes   = archiveNotes
        }
        collectionView?.reloadData()    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredNotes.removeAll()
        collectionView?.reloadData()
    }
}

// MARK: - collectionviewdelegateflowlayout
extension ArchiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let size = CGSize(width: bounds.width, height: 1000)
        let note = archiveNotes[indexPath.row]
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
