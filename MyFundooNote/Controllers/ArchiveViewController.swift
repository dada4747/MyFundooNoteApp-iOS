//
//  ArchiveViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

class ArchiveViewController: ContentViewController {
//        var collectionView: UICollectionView?

    // MARK: - Variabels
    var archiveNotes :[NoteModel]           = []
    var filteredNotes:[NoteModel]           = []
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArchiveNotes()
        configureCollectionView()
        view.backgroundColor = .secondarySystemBackground
        collectionView?.reloadData()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Archives"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArchiveNotes()
        collectionView?.reloadData()
    }
    
    // MARK: - Configure ui
    func configureCollectionView() {
        
        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: isListView ? gridFlowLayout: listFlowLayout)
        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: isListView ? gridFlowLayout: listFlowLayout)
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        collectionView.register(MyNoteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        collectionView.reloadData()
    }
    
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

// MARK: - CollectionView Delegate and Data Source

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
        let thisNote: NoteModel
        if isSearching {
            thisNote = filteredNotes[indexPath.row]
        } else {
            thisNote = archiveNotes[indexPath.row]
        }
        cell.descriptionLabel.text = thisNote.desc
        cell.titleLabel.text = thisNote.title
//        cell.note = thisNote
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AddNoteViewController()
        let thisNote = archiveNotes[indexPath.row]
        vc.trashView = true
        vc.note = thisNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

// MARK: - Search Delegate and Search Updating
extension ArchiveViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        print(searchText)
        test(text: searchText)

        if !searchText.isEmpty {
            isSearching     = true
            filteredNotes.removeAll()
            for item in archiveNotes {
                if item.title.lowercased().contains(searchText.lowercased()) == true ||
                    item.desc.lowercased().contains(searchText.lowercased()) == true {
                    filteredNotes.append(item)
                }
            }
        } else {
            isSearching     = false
            filteredNotes.removeAll()
            filteredNotes   = archiveNotes
        }
        collectionView?.reloadData()
    }

    // MARK: - TestDemo method
    func test(text: String) {
        
    }
    // MARK: - Search bar cancel method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredNotes.removeAll()
        collectionView?.reloadData()
    }
}
