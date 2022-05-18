//
//  AddReminderViewController.swift
//  MyFundooNote
//
//  Created by admin on 08/05/22.
//

import UIKit

protocol ReminderControllerDelegate : AnyObject {
    func handleRemider(date: Date )
}

class AddReminderViewController: UIViewController {
    weak var delegate   : ReminderControllerDelegate?
    let label           = TitleLabel(textAlignment: .center, fontSize: 23)
    let containerView   = CustomContainerView()
    let saveButton      = CustomButton(backgroundColor: .systemBlue, title: ConstantTitles.save)
    let cancleButton    = CustomButton(backgroundColor: .systemPink, title: ConstantTitles.cancle)
    
    let datePicker: UIDatePicker = {
            let df = UIDatePicker()
            return df
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureCancelButton()
        configureSaveButton()
        configureDatePicker()
    }

    // MARK: - UI Configuration
        
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.centerX(inView: view)
        containerView.centerY(inView: view)
        containerView.setHeight(height: 300)
        containerView.setWidth(width: 300)
    }
    
    func  configureTitleLabel() {
        containerView.addSubview(label)
        label.text = ConstantHeader.addreminder
        label.centerX(inView: containerView)
        label.anchor(top: containerView.topAnchor,
                     paddingTop: 40,
                     height: 50)
    }
    
    func  configureDatePicker() {
        containerView.addSubview(datePicker)
        datePicker.centerX(inView: containerView)
        datePicker.backgroundColor = .secondarySystemBackground
        datePicker.anchor(top: containerView.topAnchor,
                          left: containerView.leftAnchor,
                          bottom: saveButton.topAnchor,
                          right: containerView.rightAnchor,
                          paddingTop: 100,
                          paddingLeft: 20,
                          paddingBottom: 20,
                          paddingRight: 20)
    }
    func configureSaveButton() {
        containerView.addSubview(saveButton)
        let right = (containerView.frame.width / 2) + 20
        saveButton.addTarget(self, action: #selector(handleSaveReminder), for: .touchUpInside)
        saveButton.anchor( left: containerView.leftAnchor,
                           bottom: containerView.bottomAnchor,
                           right: containerView.rightAnchor,
                           paddingLeft: right + 150,
                           paddingBottom: 40,
                           paddingRight: 20)

    }
    
    func configureCancelButton() {
        containerView.addSubview(cancleButton)
        let left = (containerView.frame.width / 2) + 20
        cancleButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        cancleButton.anchor( left: containerView.leftAnchor,
                             bottom: containerView.bottomAnchor,
                             right: containerView.rightAnchor,
                             paddingLeft: 20,
                             paddingBottom: 40,
                             paddingRight: left + 150)
    }
 
    // MARK: - Handlers
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
        
    @objc func handleSaveReminder() {
        
        self.dismiss(animated: true) { [self] in
            let target = self.datePicker.date
            self.delegate?.handleRemider(date: target)
        }
    }
}

 
