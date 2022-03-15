//
//  ViewController.swift
//  Reminder
//
//  Created by Arun Kumar on 18/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class AppLoginViewController: NSViewController, AppLoginViewControllerContract {
    private var currentView: AppLoginViewContract? = nil
    private var previousViews: [AppLoginViewContract] = []
    private let welcomeView = WelcomeView()
    private let registrationView = RegistrationView()
    private let switchUserView = SwitchUserView()
    private let loginView = LoginView()
    var appLoginPresenter: AppLoginPresenterContract?
    
    deinit {
    }
    
    private enum Views {
        case welcomeView
        case registrationView
        case switchUserView
        case loginView
    }
    
    
    override func viewDidLoad() {
        print("view loaded")
        
        view.wantsLayer = true
        view.layer?.contents = NSImage(named: "background")
    }
    
    override func loadView() {
        
        view = NSView() // view will be empty until it decides what view after fetching from db
        appLoginPresenter = AppLoginPresenter()
        
        
        let success: (User) -> Void = {
            [weak self]
            (user) in
            self?.currentView = self?.loginView
            
            guard let currentView = self?.currentView else {
                return
            }
            
            
            self?.view.addSubview(currentView)
            if let viewController = self {
                self?.currentView?.load(viewController)
            }
            
            currentView.translatesAutoresizingMaskIntoConstraints = false
            currentView.widthAnchor.constraint(equalToConstant: 600).isActive = true
            currentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
            if let view = self?.view {
                currentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                currentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            } else {
                print("view is nil")
            }
        }
        
        let failure: (String) -> Void = {
            [weak self]
            (message) in
            print(message)
            self?.currentView = self?.welcomeView
            
            guard let currentView = self?.currentView else {
                return
            }
            
            
            self?.view.addSubview(currentView)
            if let viewController = self {
                self?.currentView?.load(viewController)
            }
            
            currentView.translatesAutoresizingMaskIntoConstraints = false
            currentView.widthAnchor.constraint(equalToConstant: 600).isActive = true
            currentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
            if let view = self?.view {
                currentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                currentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            } else {
                print("view is nil")
            }
        }
        
        getLastLoggedInUser(success: success, failure: failure)
    }
    
    private func fadeIn(_ view: NSView) {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.5
        fadeInAnimation.toValue = view.alphaValue
        fadeInAnimation.duration = 0.25
        self.view.wantsLayer = true
        self.view.layer?.add(fadeInAnimation, forKey: nil)
    }
    
    private func changeView(to selectedView: Views) {
        if let currentView = currentView {
            previousViews.append(currentView)
        }
        currentView?.removeFromSuperview()
        
        switch(selectedView) {
        case .welcomeView:
            currentView = welcomeView
            
        case .registrationView:
            currentView = registrationView
            
        case .switchUserView:
            currentView = switchUserView
            
        case .loginView:
            currentView = loginView
        }
        
        guard let currentView = currentView else {
            print("currentView is nil")
            return
        }

        
        fadeIn(currentView)
        
        view.addSubview(currentView)
        currentView.load(self)
        
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        
        currentView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        currentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func navigateBackToPreviousView() {
        currentView?.removeFromSuperview()
        currentView = previousViews.popLast()
        guard let currentView = currentView else {
            return
        }
        fadeIn(currentView)
        view.addSubview(currentView)
        currentView.load(self)
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        
        currentView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
    }
    
    
    func changeViewToRegistration() {
        self.changeView(to: .registrationView)
    }
    
    func changeViewToSwitchUser() {
        self.changeView(to: .switchUserView)
    }
    
    func changeViewToLogin() {
        self.changeView(to: .loginView)
    }
    
    
    func createUser(_ sender: RegistrationView) {
        let username = registrationView.usernameTextBox.stringValue
        let password = registrationView.passwordTextBox.stringValue
        let imageURL = registrationView.userImageURL
        
        // proceed only if something is entered
        if username.count == 0 {
            return
        } else if password.count == 0 {
            return
        }
        
        let success = {
            [weak self]
            (username: String) in
            sender.responseLabel.stringValue = "User \(username) created"
            sender.responseLabel.textColor = .systemGreen
            sender.responseLabel.isHidden = false
            self?.changeViewToSwitchUser()
        }
        
        let failure = {
            (message: String) in
            sender.responseLabel.stringValue = message
            sender.responseLabel.textColor = .systemRed
            sender.responseLabel.isHidden = false
        }

        appLoginPresenter?.createUser(username: username, password: password, imageURL: imageURL, onSuccess: success, onFailure: failure)
        
    }
    
    func getAllUsers(success: @escaping ([User]) -> Void, failure: @escaping (String) -> Void) {
        appLoginPresenter?.getAllUsers(onSuccess: success, onFailure: failure)
    }
    
    func getLastLoggedInUser(success: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
        appLoginPresenter?.getLastLoggedInUser(onSuccess: success, onFailure: failure)
    }
    
    func setLastLoggedInUser(_ user: User) {
        appLoginPresenter?.setLastLoggedInUser(user: user)
    }
}



