//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by Koty Stannard on 1/8/22.
//

import UIKit

let passwordToggleButton = UIButton(type: .custom)

extension UITextField {
    
    func enablePasswordToggle() {
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = passwordToggleButton
        rightViewMode = .always
    }
    
    @objc fileprivate func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
}
