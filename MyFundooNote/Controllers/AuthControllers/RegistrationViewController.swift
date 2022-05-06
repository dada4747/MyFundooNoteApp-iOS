//
//  RegistrationViewController.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "pro") , for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
        
    private lazy var emailContainerView: UIView      = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var fullNameContainerView: UIView   = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
    }()
    
    private lazy var userNameContainerView: UIView   = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: userNameTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passTextField)
    }()
    
    private let emailTextField      = CustomTextField(placeholder: "Email")
    private let fullNameTextField   = CustomTextField(placeholder: "Full Name")
    private let userNameTextField   = CustomTextField(placeholder: "User Name")
    
    private let passTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    let signUpButton = CustomButton(backgroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), title: "Sign Up")

    private let alreadyHaveAccButton = TextButton(firstTitle: "Already have an account? ", secondTitle: "Log In")
   
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: - Selector
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }

        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullName, username: userName, profileImage: profileImage)
        AuthService.shared.createUserIn(credentials: credentials) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        } else if sender == passTextField {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureSignUpButton()
//        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                                                   passwordContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(alreadyHaveAccButton)
        alreadyHaveAccButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)

        alreadyHaveAccButton.anchor(left: view.leftAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingLeft: 32,
                                    paddingRight: 32)
    }
    func configureSignUpButton() {
        signUpButton.layer.cornerRadius = 6
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.setHeight(height: 50)
        signUpButton.isEnabled = false
        signUpButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    }
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor   = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth   = 3.0
        plusPhotoButton.layer.cornerRadius  = 200 / 2
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AuthenticationControllerProtocol
extension RegistrationViewController: AuthenticationControllerProtocol {

    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled          = true
            signUpButton.backgroundColor    = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            signUpButton.isEnabled          = false
            signUpButton.backgroundColor    = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
    }
}
