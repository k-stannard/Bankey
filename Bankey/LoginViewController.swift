//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    //MARK: - UI
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorLabel = UILabel()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    weak var delegate: LoginControllerDelegate?
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }
    
    //MARK: - Animation Variables
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEdgeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var subtitleLeadingAnchor: NSLayoutConstraint?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
}

//MARK: - Controller Style & Layout
extension LoginViewController {
    
    fileprivate func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.text = "Bankey"
        titleLabel.textAlignment = .center
        titleLabel.alpha = 0
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitleLabel.text = "Your premiums source for all things banking!"
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.alpha = 0
        
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
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            
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
        
        titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        subtitleLeadingAnchor?.isActive = true
    }
}

//MARK: - Action Setup
extension LoginViewController {
    
    @objc fileprivate func handleSignIn() {
        errorLabel.isHidden = true
        login()
    }
    
    fileprivate func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username/password should never be nil")
            return
        }
        
//        if username.isEmpty || password.isEmpty {
//            configureView(withMessage: "Username and/or password is blank.")
//            return
//        }
        
        if username == "" && password == "" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username and/or password.")
        }
    }
    
    fileprivate func configureView(withMessage message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
        shakeErrorLabel()
    }
}

//MARK: - Animations
extension LoginViewController {
    private func animate() {
        let duration: CGFloat = 1.25
        
        let titleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        titleAnimator.startAnimation()
        
        let subtitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.subtitleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        subtitleAnimator.startAnimation(afterDelay: 1)
        
        let titleAlphaAnimator = UIViewPropertyAnimator(duration: duration * 2, curve: .easeInOut) {
            self.titleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        titleAlphaAnimator.startAnimation(afterDelay: 0.2)
        
        let subtitleAlphaAnimator = UIViewPropertyAnimator(duration: duration * 2, curve: .easeInOut) {
            self.subtitleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        subtitleAlphaAnimator.startAnimation(afterDelay: 0.75)
    }
    
    private func shakeErrorLabel() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        
        animation.isAdditive = true
        errorLabel.layer.add(animation, forKey: "shake")
    }
}
