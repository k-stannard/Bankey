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
    let mainViewController = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginController.delegate = self
        onboardingContainerController.delegate = self
        
        displayLogin()
        return true
    }
    
    private func displayLogin() {
        setRootViewController(loginController)
    }
    
    private func displayNextScreen() {
        if LocalState.hasOnboarded {
            prepareMainView()
            setRootViewController(mainViewController)
        } else {
            setRootViewController(onboardingContainerController)
        }
    }
    
    private func prepareMainView() {
        mainViewController.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
    }
}

extension AppDelegate: LoginControllerDelegate {
    
    func didLogin() {
        displayNextScreen()
    }
}

extension AppDelegate: ContainerControllerDelegate {
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepareMainView()
        setRootViewController(mainViewController)
    }
}

extension AppDelegate: LogoutDelegate {
    
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
