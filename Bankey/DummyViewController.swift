//
//  DummyViewController.swift
//  Bankey
//
//  Created by Koty Stannard on 1/2/22.
//

import UIKit

class DummyViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    let logoutBUtton = UIButton(type: .system)
    
    weak var logoutDelegate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension DummyViewController {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        logoutBUtton.translatesAutoresizingMaskIntoConstraints = false
        logoutBUtton.configuration = .filled()
        logoutBUtton.setTitle("Logout", for: .normal)
        logoutBUtton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    func layout() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutBUtton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func handleLogout(sender: UIButton) {
        logoutDelegate?.didLogout()
    }
}
