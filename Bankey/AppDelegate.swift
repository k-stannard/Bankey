//
//  AppDelegate.swift
//  Bankey
//
//  Created by Koty Stannard on 1/1/22.
//

import UIKit

let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loginController = LoginController()
    let onboardingContainerController = ContainerController()
    let dummyController = DummyViewController()
    let mainViewController = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginController.delegate = self
        onboardingContainerController.delegate = self
        dummyController.logoutDelegate = self
        
        window?.rootViewController = mainViewController
        
        return true
    }
}

extension AppDelegate: LoginControllerDelegate, ContainerControllerDelegate, LogoutDelegate {
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(dummyController)
        } else {
            setRootViewController(onboardingContainerController)
        }
    }
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(dummyController)
    }
    
    func didLogout() {
        setRootViewController(loginController)
    }
}

extension AppDelegate {
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
