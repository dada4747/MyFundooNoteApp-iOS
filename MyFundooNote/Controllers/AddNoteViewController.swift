//
//  AddNoteViewController.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import UIKit
import UserNotifications
import CloudKit

class AddNoteViewController: UIViewController {
    
    
    // MARK: - Variables
    var note            : NoteModel?
    var trashView       : Bool?
    let pine            : UIImage?    = UIImage(systemName: "pin.circle")
    let reminder        : UIImage?    = UIImage(systemName: "bell.circle")
    let archive         : UIImage?    = UIImage(systemName: "archivebox.circle")
    let delete          : UIImage?    = UIImage(systemName: "trash.circle")
    let backImage       : UIImage?    = UIImage(systemName: "arrow.backward.circle")
    let unarchiveImage  : UIImage?    = UIImage(systemName: "archivebox.circle.fill")
    
    let titleLabel                    = TitleLabel(textAlignment: .left, fontSize: 23)
    let descLabel                     = BodyLabel(textAlignment: .left)
    let titleTextView                 = CustomTextView(placeholder: "Title", fontSize: 23)
    let descriptionTextView           = CustomTextView(placeholder: "Description", fontSize: 17)
    
    var keyboardHeight: CGFloat = 0.0
    
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            descriptionBottomConstraints.isActive = false
            descriptionBottomConstraints = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -(keyboardHeight + 10))
             descriptionBottomConstraints.isActive = true
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        descriptionBottomConstraints.isActive = false
        descriptionBottomConstraints = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -20)
         descriptionBottomConstraints.isActive = true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        let pineButtonItem      = UIBarButtonItem(image: pine,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(pineTapped))
        let reminderButtonItem  = UIBarButtonItem(image: reminder,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(reminderTapped))
        let archiveButtonItem   = UIBarButtonItem(image: archive,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleArchiveTapped))
        let deleteButtonItem    = UIBarButtonItem(image: delete,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleDeleteTapped))
        let unArchiveButtonItem = UIBarButtonItem(image: unarchiveImage,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleUnArchiveTapped))
        let backButtonItem      = UIBarButtonItem(image: backImage,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleBackButton))
        
        navigationItem.setLeftBarButton(backButtonItem, animated: false)
        
        if(trashView != nil && trashView == true) {
            navigationItem.setRightBarButtonItems([deleteButtonItem,
                                                   pineButtonItem,
                                                   reminderButtonItem,
                                                   unArchiveButtonItem], animated: false)
        } else if(note?.id != nil) {
            navigationItem.setRightBarButtonItems([deleteButtonItem,
                                                   pineButtonItem,
                                                   reminderButtonItem,
                                                   archiveButtonItem], animated: false)
            
        } else {
            navigationItem.setRightBarButtonItems([pineButtonItem,
                                                   reminderButtonItem,
                                                   archiveButtonItem], animated: false)
        }
    }
    
    func configureTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.delegate                                  = self
        titleTextView.isScrollEnabled                           = false
        titleTextView.sizeToFit()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 20,
                             paddingLeft: 20,
                             paddingRight: 20,
                             height: 50)
    }
    
    func configureTitleLabel() {
        titleTextView.addSubview(titleLabel)
        titleLabel.text = "Title"
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerY(inView: titleTextView)
        titleLabel.anchor(left: titleTextView.leftAnchor, right: titleTextView.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 40)
    }
    var descriptionBottomConstraints: NSLayoutConstraint!
    
    func configureDescriptionTextView(){
        view.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.sizeToFit()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextView.anchor(top: titleTextView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom:  20, paddingRight: 20)
//        descriptionTextView.anchor(top: titleTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        
        ])
       descriptionBottomConstraints = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        descriptionBottomConstraints.isActive = true
        
    }
    
    func configureDescriptionLabel() {
        descriptionTextView.addSubview(descLabel)
        descLabel.text = "Description"
        descLabel.textColor = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.anchor(top:descriptionTextView.topAnchor, left: descriptionTextView.leftAnchor,right: descriptionTextView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, height: 40)
    }
    
    // MARK: - Functions
    
    // MARK: - Handlers
    @objc func pineTapped(){
        
    }
    
    @objc func reminderTapped(){
        DispatchQueue.main.async {
            let provc = AddReminderViewController()
            provc.delegate = self
            provc.modalPresentationStyle  = .overFullScreen
            provc.modalTransitionStyle    = .crossDissolve
            self.present(provc, animated: true)
        }
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
                print(":::::::::::::::::::::::::::::::::::::")
                print(error?.localizedDescription)
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
            
        } else if (note?.id != nil && trashView == true ){
            FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: true, isNote: note!.isNote, isReminder: note!.isReminder) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return 
        }else if(note?.id != nil){
            FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: note!.isArchive, isNote: note!.isNote, isReminder: note!.isReminder) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else if(title.isEmpty && desc.isEmpty) {
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == titleTextView && !textView.text.isEmpty) {
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = 100
                }
            }
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

extension AddNoteViewController: ReminderControllerDelegate {
    func setReminder(title: String, body:String, targetDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
            }
        }
        let targetDate1 = targetDate
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate1), repeats: false)
        let request  = UNNotificationRequest(identifier: "The note Reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { err in
            if err != nil{
                print("something went is wrog happen")
            }
        }
    }
    
    func handleRemider(date: Date) {
        let title = titleTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trashView == nil && note?.id == nil) {
            if !title.isEmpty || !desc.isEmpty {
                FirebaseNotsService.shared.writeToFirebase(title: titleTextView.text, description: descriptionTextView.text, isRemainder: true, isArchieved: false, isNote: true)
                
                DispatchQueue.main.async{
                    self.setReminder(title: title, body: desc, targetDate: date)
                    
                }
                navigationController?.popViewController(animated: true)
            }
            
        } else if (note?.id != nil ){
            FirebaseNotsService.shared.updateDataToFirebase(note: note!.id, title: titleTextView.text, desc: descriptionTextView.text, isArchive: false, isNote: note!.isNote, isReminder: true) { error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
                DispatchQueue.main.async{
                    self.setReminder(title: title, body: desc, targetDate: date)
                }
            }
        } else if(title.isEmpty && desc.isEmpty) {
            navigationController?.popViewController(animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
}
