//
//  AddNoteViewController.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import UIKit
import CloudKit

class AddNoteViewController: UIViewController {
    // MARK: - Variables
    var pine            : UIImage?    = UIImage(systemName: "pin.circle")
    var reminder        : UIImage?    = UIImage(systemName: "bell.circle")
    var archive         : UIImage?    = UIImage(systemName: "archivebox.circle")
    var delete          : UIImage?    = UIImage(systemName: "trash.circle")
    var backImage       : UIImage?    = UIImage(systemName: "arrow.backward.circle")
    var unarchiveImage  : UIImage?    = UIImage(systemName: "archivebox.circle.fill")
    
    let titleLabel              = TitleLabel(textAlignment: .left, fontSize: 23)
    let descLabel               = BodyLabel(textAlignment: .left)
    let titleTextView           = CustomTextView(placeholder: "Title", fontSize: 23)
    let descriptionTextView     = CustomTextView(placeholder: "Description", fontSize: 17)
    
    var note      : NoteModel?
    var trashView : Bool?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.text          = note?.title
        descriptionTextView.text    = note?.desc
        if(!titleTextView.text.isEmpty) {
            titleLabel.isHidden     = true
            descLabel.isHidden      = true
        }
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
    }
    
    // MARK: - ConfugureUI
    
    func configureView() {
        view.backgroundColor = .secondarySystemBackground
        
        configureNavigationBar()
        configureTitleTextView()
        configureTitleLabel()
        configureDescriptionTextView()
        configureDescriptionLabel()
    }
    
    func configureNavigationBar(){
        let pineButtonItem      = UIBarButtonItem(image: pine, style: .plain, target: self, action: #selector(pineTapped))
        let reminderButtonItem  = UIBarButtonItem(image: reminder, style: .plain, target: self, action: #selector(reminderTapped))
        let archiveButtonItem   = UIBarButtonItem(image: archive, style: .plain, target: self, action: #selector(handleArchiveTapped))
        let deleteButtonItem    = UIBarButtonItem(image: delete, style: .plain, target: self, action: #selector(handleDeleteTapped))
        let unArchiveButtonItem = UIBarButtonItem(image: unarchiveImage, style: .plain, target: self, action: #selector(handleUnArchiveTapped))
        let backButtonItem      = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(handleBackButton))
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.setLeftBarButton(backButtonItem, animated: false)
        
        if(trashView != nil && trashView == true) {
            navigationItem.setRightBarButtonItems([deleteButtonItem, pineButtonItem, reminderButtonItem,unArchiveButtonItem], animated: false)
        } else if(note?.id != nil) {
            navigationItem.setRightBarButtonItems([deleteButtonItem, pineButtonItem, reminderButtonItem,archiveButtonItem], animated: false)
            
        } else {
            navigationItem.setRightBarButtonItems([pineButtonItem, reminderButtonItem,archiveButtonItem], animated: false)
        }
    }
    
    func configureTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.delegate = self
        titleTextView.isScrollEnabled = false
        titleTextView.sizeToFit()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20,height: 50)
    }
    
    func configureTitleLabel() {
        titleTextView.addSubview(titleLabel)
        titleLabel.text = "Title"
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerY(inView: titleTextView)
        titleLabel.anchor(left: titleTextView.leftAnchor, right: titleTextView.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 40)
    }
    
    func configureDescriptionTextView(){
        view.addSubview(descriptionTextView)
        
        descriptionTextView.delegate = self
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.sizeToFit()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.anchor(top: titleTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    func configureDescriptionLabel() {
        descriptionTextView.addSubview(descLabel)
        descLabel.text = "Description"
        descLabel.textColor = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.centerY(inView: descriptionTextView)
        descLabel.anchor(left: descriptionTextView.leftAnchor, right: descriptionTextView.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 40)
    }
    
    // MARK: - Functions
    
    // MARK: - Handlers
    @objc func pineTapped(){
        
    }
    @objc func reminderTapped(){
        
        
    }
    @objc func handleUnArchiveTapped(){
        if(note?.id != nil) {
            FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: false, isNote: note!.isNote, isReminder: note!.isReminder) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
            
        }
    }
    @objc func handleArchiveTapped(){
        let title   = titleTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc    = descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty || !desc.isEmpty {
            print("in archive tapp not empty")
            if(note?.id != nil) {
                
                FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: true, isNote: note!.isNote, isReminder: note!.isReminder) { error in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)

                    } else {
                        print("error found")
                    }
                }
                return
            } else {
                print("archive not empty")
                FirebaseNotsService.shared.writeToFirebase(title: titleTextView.text, description: descriptionTextView.text, isRemainder: false, isArchieved: true, isNote: false)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func handleDeleteTapped() {
        FirebaseNotsService.shared.deleteDataToFirebase(noteId: note!.id) { error in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }else {
                // MARK: - Todo
                print("show pop up")
            }
        }
    }
    
    @objc func handleBackButton() {
        print("initial back tapped")
        let title = titleTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trashView == nil && note?.id == nil) {

            if !title.isEmpty || !desc.isEmpty {
                FirebaseNotsService.shared.writeToFirebase(title: titleTextView.text, description: descriptionTextView.text, isRemainder: false, isArchieved: false, isNote: true)
                navigationController?.popViewController(animated: true)
            }
            
        } else if (note?.id != nil ){
            FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: note!.isArchive, isNote: note!.isNote, isReminder: note!.isReminder) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else if(title.isEmpty && desc.isEmpty) {
            navigationController?.popViewController(animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: textView.frame.height)
        let estimateSize  = textView.sizeThatFits(size)
        if(textView == descriptionTextView ) {
            if textView.contentSize.height >= 250 {
                textView.isScrollEnabled = true
            } else {
                textView.frame.size.height = textView.contentSize.height
                textView.isScrollEnabled = false
            }
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimateSize.height >= 250 ? 250 : estimateSize.height
                }
            }
        } else if(textView == titleTextView){
            
            if textView.contentSize.height >= 100 {
                textView.isScrollEnabled = true
            } else {
                textView.frame.size.height = textView.contentSize.height
                textView.isScrollEnabled = false
            }
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimateSize.height >= 100 ? 100 : estimateSize.height
                }
            }
        }
        if(textView == titleTextView) {
            titleLabel.isHidden = !textView.text.isEmpty
        } else {
            descLabel.isHidden = !textView.text.isEmpty
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textView.resignFirstResponder()
        return true
    }
}