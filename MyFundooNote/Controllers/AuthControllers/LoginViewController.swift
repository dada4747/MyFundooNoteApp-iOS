//
//  LoginViewController.swift
//  MyFundooNote
//
//  Created by admin on 30/04/22.
//

import UIKit
import Firebase

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

class LoginViewController: UIViewController {

    
       // MARK: - Properties
       
       private var viewModel = LogInViewModel()
       
       private let iconImage: UIImageView = {
           let iv = UIImageView()
           iv.image = ConstantImages.noteImage
           return iv
       }()
       
       private lazy var emailContainerView: UIView = {
           return InputContainerView(image: #imageLiteral(resourceName: ConstatResourceName.mail ),
                                     textField: emailTextField)
       }()
       
       private lazy var passwordContainerView: InputContainerView = {
           return InputContainerView(image: #imageLiteral(resourceName:ConstatResourceName.lock ),
                                     textField: passTextField)
       }()
    let loginButton = CustomButton(backgroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), title: ConstantTitles.login)

    let dontHaveAccButton = TextButton(firstTitle: "Don't have an account? ", secondTitle: ConstantTitles.signup)
    private let emailTextField = CustomTextField(placeholder: ConstantPlaceholders.email)
       
       private let passTextField: CustomTextField = {
           let tf = CustomTextField(placeholder: ConstantPlaceholders.password)
           tf.isSecureTextEntry = true
           return tf
       }()
       
       // MARK: - LifeCycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
           configureUI()
       }
       
       // MARK: - Selectore
       
       @objc func handleLogin() {
           guard let email = emailTextField.text else { return }
           guard let password = passTextField.text else { return }
           
           AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
               if let error = error {
                   print("DEBUG: faill to login with error \(error.localizedDescription)")
                   return
               }
               self.dismiss(animated: true, completion: nil)
           }
       }
       
       @objc func handleShowSignup() {
           let vc = RegistrationViewController()
           navigationController?.pushViewController(vc, animated: true)
       }
       
       @objc func textDidChange(sender: UITextField) {
           if sender == emailTextField {
               viewModel.email = sender.text
           } else {
               viewModel.password = sender.text
           }
           checkFormStatus()
       }
       
       // MARK: - Helper
       func configureUI() {
           navigationController?.navigationBar.isHidden = true
           navigationController?.navigationBar.barStyle = .black
           view.backgroundColor = .secondarySystemBackground
//           configureGradientLayer()
           configureLogInButton()
           view.addSubview(iconImage)
           iconImage.centerX(inView: view)
           iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
           iconImage.setDimensions(height: 250, width: 250)
           
           let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                      passwordContainerView,
                                                      loginButton])
           stack.axis = .vertical
           stack.spacing = 16
           view.addSubview(stack)
           stack.anchor(top: iconImage.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 32,
                        paddingLeft: 32,
                        paddingRight: 32)
           
           view.addSubview(dontHaveAccButton)
           dontHaveAccButton.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
           dontHaveAccButton.anchor(left: view.leftAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingLeft: 32,
                                    paddingRight: 32)
           
           emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
           passTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

       }
    func configureLogInButton() {
        loginButton.layer.cornerRadius = 6
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ConstantFontSize.descriptionFontsize)
        loginButton.setHeight(height: 50)
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

}

// MARK: - AuthenticationControllerProtocol
extension LoginViewController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
    }
}
