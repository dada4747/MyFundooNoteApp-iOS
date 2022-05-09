//
//  Profile2.swift
//  MyFundooNote
//
//  Created by admin on 05/05/22.
//

import UIKit
import Firebase
import SDWebImage

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileViewController: UIViewController {
    
    weak var delegate   : ProfileControllerDelegate?

    let containerView       = CustomContainerView()
    let profileImageView    = ProfileImageView(frame: .zero)
    let titleLabel          = TitleLabel(textAlignment: .center, fontSize: 27)
    let fullNameLabel       = TitleLabel(textAlignment: .center, fontSize: 23)
    let emailIdLabel        = BodyLabel(textAlignment: .center)
    let LogoutButton        = CustomButton(backgroundColor: .systemPink, title: "Logout")
    
    var user: User? {
        didSet { populateUserData() }
    }
    
    private let dismissButton : UIButton = {
        let button       = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "multiply.circle"),
                        for: .normal)
        button.imageView?.setDimensions(height: 28, width: 28)
        return button
    }()

    private let privacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Privacy Policy ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.label])
        button.setAttributedTitle(attributedTitle,
                                  for: .normal)
        return button
    }()
    
    private let termAndServiceButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Term And Service ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.label])
        button.setAttributedTitle(attributedTitle,
                                  for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureTapGesture()
        configureContainerView()
        configureTitleLabel()
        configureProfileImageView()
        configureDissmissButton()
        configureFullNameLabel()
        configureEmailIdLabel()
        configureTermAndServiceButton()
        configurePrivacyPolicyButton()
        configureLogoutButton()
    }
    
    // MARK: - UI Configuration
        
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 100,
                             paddingLeft: 20,
                             paddingRight: 20,
                             height: 400)
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = "Google Keep"
        titleLabel.centerX(inView: containerView)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                            constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                             constant: -20).isActive = true
        titleLabel.anchor(top: containerView.topAnchor, paddingTop: 20,
                          height: 28)
    }
    
    func configureProfileImageView() {
        containerView.addSubview(profileImageView)
        profileImageView.centerX(inView:containerView)
        profileImageView.anchor(top: titleLabel.bottomAnchor,
                                paddingTop: 20,
                                width: 100,
                                height: 100)
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height / 2
    }
    
    func configureFullNameLabel(){
        containerView.addSubview(fullNameLabel)
        fullNameLabel.centerX(inView: containerView)
        fullNameLabel.anchor(top: profileImageView.bottomAnchor,
                             paddingTop: 20, height: 20)
    }
    
    func configureEmailIdLabel(){
        containerView.addSubview(emailIdLabel)
        emailIdLabel.centerX(inView: containerView)
        emailIdLabel.anchor(top: fullNameLabel.bottomAnchor,
                            paddingTop: 10,
                            height: 20)
    }
    
    func configureTermAndServiceButton(){
        containerView.addSubview(termAndServiceButton)
        termAndServiceButton.addTarget(self, action: #selector(handlePrivacyTapped), for: .touchUpInside)
        termAndServiceButton.anchor( bottom: containerView.bottomAnchor,
                                     right: containerView.rightAnchor,
                                     paddingBottom: 20,
                                     paddingRight: 32)
    }
    
    func configurePrivacyPolicyButton(){
        containerView.addSubview(privacyPolicyButton)
        privacyPolicyButton.addTarget(self, action: #selector(handlePrivacyTapped), for: .touchUpInside)
        privacyPolicyButton.anchor(left: containerView.leftAnchor,
                                   bottom: containerView.bottomAnchor,
                                   paddingLeft: 32,
                                   paddingBottom: 20)
    }
    
    func configureLogoutButton(){
        containerView.addSubview(LogoutButton)
        LogoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        LogoutButton.anchor(left: containerView.leftAnchor, bottom: privacyPolicyButton.topAnchor, right: containerView.rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40, height: 50)

    }
    
    func configureDissmissButton(){
        containerView.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        dismissButton.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        dismissButton.setDimensions(height: 28, width: 28)
    }
    
    // MARK: - Functions
    
    func populateUserData(){
        guard let user      = user else { return }
        fullNameLabel.text  = user.fullname
        emailIdLabel.text   = user.email
        guard let url       = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
    func configureTapGesture(){
        let gestureRecongnizer      = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        gestureRecongnizer.delegate = self
        view.addGestureRecognizer(gestureRecongnizer)
    }
    
    // MARK: - Handlers
    
    @objc func handlePrivacyTapped(){
        
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true)
    }
        
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure want to Logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, let gestureView = gestureRecognizer.view, touchedView.isDescendant(of: gestureView), touchedView !== gestureView {
            return false
        }
        return true
    }
}
 
