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

    let titleLabel              = TitleLabel(textAlignment: .left,
                                             fontSize: ConstantFontSize.titleFontSize)
    let descLabel               = BodyLabel(textAlignment: .left)
    let titleTextView           = CustomTextView(placeholder: ConstantPlaceholders.title,
                                                 fontSize: ConstantFontSize.titleFontSize)
    let descriptionTextView     = CustomTextView(placeholder: ConstantPlaceholders.disc,
                                                 fontSize: ConstantFontSize.descriptionFontsize)
    var keyboardHeight: CGFloat = 0.0
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if(!titleTextView.text.isEmpty) {
            titleLabel.isHidden     = true
            descLabel.isHidden      = true
        }
        configureView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
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
        let pineButtonItem      = UIBarButtonItem(image: ConstantImages.pine,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(pineTapped))
        let reminderButtonItem  = UIBarButtonItem(image: ConstantImages.reminder,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(reminderTapped))
        let archiveButtonItem   = UIBarButtonItem(image: ConstantImages.archive,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleArchiveTapped))
        let deleteButtonItem    = UIBarButtonItem(image: ConstantImages.delete,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleDeleteTapped))
        let unArchiveButtonItem = UIBarButtonItem(image: ConstantImages.unarchiveImage,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleUnArchiveTapped))
        let backButtonItem      = UIBarButtonItem(image: ConstantImages.backImage,
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
        titleLabel.text                                      = ConstantPlaceholders.title
        titleLabel.textColor                                 = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerY(inView: titleTextView)
        titleLabel.anchor(left: titleTextView.leftAnchor,
                          right: titleTextView.rightAnchor,
                          paddingLeft: 10,
                          paddingRight: 10,
                          height: 40)
    }
    var descriptionBottomConstraints: NSLayoutConstraint!
    
    func configureDescriptionTextView(){
        view.addSubview(descriptionTextView)
        descriptionTextView.delegate                                  = self
        descriptionTextView.isScrollEnabled                           = false
        descriptionTextView.sizeToFit()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor,
                                                     constant: 10),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                      constant: 20),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                       constant: -20),
        ])
       descriptionBottomConstraints = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                  constant: -20)
        descriptionBottomConstraints.isActive = true
    }
    
    func configureDescriptionLabel() {
        descriptionTextView.addSubview(descLabel)
        descLabel.text                                      = ConstantPlaceholders.disc
        descLabel.textColor                                 = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.anchor(top:descriptionTextView.topAnchor,
                         left: descriptionTextView.leftAnchor,
                         right: descriptionTextView.rightAnchor,
                         paddingTop: 5,
                         paddingLeft: 10,
                         paddingRight: 10,
                         height: 40)
    }
    
    // MARK: - Functions
    func setup(){
        if note != nil {
            titleTextView.text          = note?.title
            descriptionTextView.text    = note?.discription
        } else {
            FirebaseNotsService.shared.createEmptyNote { note in
                self.note = note
            }
        }
    }
    func saveIfNoteIsNotEmpty() {
        guard let note = note else { return }
        if !note.title.isEmpty && !note.discription.isEmpty {
            FirebaseNotsService.shared.updateNoteToFirebase(note: note) { err in
                if err != nil {
                    return
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    func deleteNoteIfIsEmpty() {
        guard let note = note else { return }
        if note.title.isEmpty || note.discription.isEmpty {
            FirebaseNotsService.shared.deleteDataToFirebase(noteId: note.id) { error in
                if error != nil {
                    return
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
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
//        DataPersistanceManager.shared.updateWith(model: note!) { result in
//            switch result {
//            case .success(let result):
//                print("*********************************")
//                print(result)
//            case.failure(let err):
//                print(err)
//            }
//        }
        handleBackButton()
    }
    @objc func handleArchiveTapped(){
        guard let note       = note else { return }
        self.note?.isArchive = !note.isArchive
        handleBackButton()
    }
    
    @objc func handleDeleteTapped() {
        LoaderAnimator.sharedInstance.show()
        FirebaseNotsService.shared.deleteDataToFirebase(noteId: note!.id) { err in
            if err != nil {
                // MARK: - Todo
                self.presentGFAlertOnMainThread(title: "Delete Note", message: "unable to delete the note", buttonTitle: "Ok")
                return
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @objc func handleBackButton() {
        saveIfNoteIsNotEmpty()
        deleteNoteIfIsEmpty()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue             = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle                 = keyboardFrame.cgRectValue
            self.keyboardHeight                   = keyboardRectangle.height
            descriptionBottomConstraints.isActive = false
            descriptionBottomConstraints          = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                                constant:  -(keyboardHeight + 10))
             descriptionBottomConstraints.isActive = true
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        descriptionBottomConstraints.isActive = false
        descriptionBottomConstraints          = descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                            constant:  -20)
         descriptionBottomConstraints.isActive = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: textView.frame.height)
        let estimateSize  = textView.sizeThatFits(size)
        if(textView == descriptionTextView ) {
            note?.discription = textView.text
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
            
            note?.title = textView.text
            
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
        let content     = UNMutableNotificationContent()
        content.title   = title
        content.sound   = .default
        content.body    = body
        let center      = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,
                                              .sound,
                                              .badge]) { granted, error in
            if error != nil {
            }
        }
        let targetDate1 = targetDate
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,
                                                                                                   .month,
                                                                                                   .day,
                                                                                                   .hour,
                                                                                                   .minute,
                                                                                                   .second],
                                                                                                  from: targetDate1),
                                                    repeats: false)
        let request  = UNNotificationRequest(identifier: "The note Reminder",
                                             content: content,
                                             trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { err in
            if err != nil{
                print("something went is wrog happen")
            }
        }
    }
    
    func handleRemider(date: Date) {
        
        note?.isReminder = true
        guard let note = note else { return }

        DispatchQueue.main.async {
            self.setReminder(title: note.title,
                             body: note.discription,
                             targetDate: date)
            
        }
        handleBackButton()
    }
}
