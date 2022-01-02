//
//  ViewController.swift
//  Bankey
//
//  Created by Koty Stannard on 1/1/22.
//

import UIKit

protocol LoginControllerDelegate: AnyObject {
    func didLogin()
}

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

class LoginController: UIViewController {

    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorLabel = UILabel()
    
    weak var delegate: LoginControllerDelegate?
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
    }
}

//MARK: - Controller Style & Layout
extension LoginController {
    
    fileprivate func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
    }
    
    fileprivate func layout() {
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 2),
            
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            errorLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}

//MARK: - Action Setup
extension LoginController {
    
    @objc fileprivate func handleSignIn() {
        errorLabel.isHidden = true
        login()
    }
    
    fileprivate func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username/password should never be nil")
            return
        }
        
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username and/or password is blank.")
            return
        }
        
        if username == "Koty" && password == "123123" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username and/or password.")
        }
    }
    
    fileprivate func configureView(withMessage message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
}
