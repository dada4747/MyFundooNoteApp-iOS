//
//  ArchiveViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit
import AVKit
import AVFoundation

class ArchiveViewController: ContentViewController {
    
    // MARK: - Variabels
    var archiveNotes :[NoteModel]?          = []
    var filteredNotes:[NoteModel]           = []
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: PinterestLayout())
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {             layout.delegate = self
        }
               
                collectionView.register(MyNoteCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView!)
        collectionView.backgroundColor  = .secondarySystemBackground
                       collectionView.translatesAutoresizingMaskIntoConstraints = false
                       collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                             left: view.leftAnchor,
                                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                             right: view.rightAnchor,
                                             paddingTop: 10,
                                             paddingLeft: 0,
                                             paddingBottom: 10,
                                             paddingRight: 0)
        fetchArchiveNotes()
        view.backgroundColor = .secondarySystemBackground
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Search Archives"
        collectionView.dataSource              = self
        collectionView.delegate                = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArchiveNotes()
    }

    
    // MARK: - Configure ui
    
    // MARK: - Functions
    func fetchArchiveNotes() {
        FirebaseNotsService.shared.fetchArchive { [weak self] notes in
            guard let self = self else { return }

            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.archiveNotes       = notes
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
                
            }
    }
    
    func fetchMoreArchiveNotes() {
        FirebaseNotsService.shared.fetchMoreArchive { [weak self] notes in
                        guard let self = self else { return }

            if notes.count < 10 {
                self.hasMoreNotes = false
            } else {
                self.hasMoreNotes = true
            }
            self.archiveNotes?.append(contentsOf: notes)
            print("paginatino call here")
            DispatchQueue.main.async {
                print("***********************************")
                self.collectionView?.reloadData()
            }
        }
    }
}


// MARK: - Data source and delegate
extension ArchiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredNotes.count
        } else {
            return archiveNotes!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyNoteCollectionViewCell
        var thisNote: NoteModel
        if isSearching {
            thisNote     = filteredNotes[indexPath.row]
        } else {
            thisNote     = archiveNotes![indexPath.row]
        }
        cell.descriptionLabel.text = thisNote.desc
        cell.titleLabel.text = thisNote.title
        //        cell.note    = thisNote
        return cell
    }
    
}
extension ArchiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc          = AddNoteViewController()
        let thisNote    = archiveNotes?[indexPath.row]
        vc.trashView    = true
        vc.note         = thisNote
//        print("this is did select of archives\(thisNote?.title)")
        navigationController?.pushViewController(vc, animated: true)
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(hasMoreNotes)
        if( hasMoreNotes && indexPath.row == archiveNotes!.count-1  ) {
            print("Load more notes")
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
extension ArchiveViewController: PinterestLayoutDelegate {
   
    func collectionView(collectionView: UICollectionView, heightForTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let note = archiveNotes?[indexPath.item] {
            let topPadding = CGFloat(5)
            let bottomPadding = CGFloat(5)
            let titleFont = UIFont.systemFont(ofSize: 23)
            let titleHeight = self.heightOfText(for: note.title, with: titleFont, width: width - 10 )
            let height = topPadding + titleHeight + topPadding + bottomPadding
//            print("height of title label of note cell\(height)")
            return height
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let note = archiveNotes?[indexPath.item] {
            let topPadding = CGFloat(5)
            let bottomPadding = CGFloat(5)
            let descFont = UIFont.systemFont(ofSize: 17)
            let descHeight = self.heightOfText(for: note.desc, with: descFont, width: width - 10)
            let height = topPadding + descHeight + topPadding + bottomPadding
//            print("height of desc label of note cell\(height)")

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
        print("this is height of text ")
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(1503)
        let textAtributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight),options: .usesLineFragmentOrigin,attributes: textAtributes, context: nil)
        return ceil(boundingRect.height)
    }
}








// MARK: - Extension ResultUpdating and Search bar delegate
extension ArchiveViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText      = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching     = true
            filteredNotes.removeAll()
            for item in archiveNotes! {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true {
                    filteredNotes.append(item)
                }
            }
        }
        else {
            isSearching     = false
            filteredNotes.removeAll()
            filteredNotes   = archiveNotes!
        }
        collectionView?.reloadData()    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredNotes.removeAll()
        collectionView?.reloadData()
    }
}

