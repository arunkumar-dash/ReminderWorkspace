//
//  SwitchUserView.swift
//  Reminder
//
//  Created by Arun Kumar on 18/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class SwitchUserView: NSView, AppLoginViewContract {
    private let selectUserLabel = NSTextField(labelWithString: "Select User")
    private var userStackView = NSStackView()
    private let createUserButtonText = NSTextField(labelWithAttributedString: NSAttributedString(string: "Create User", attributes: [.foregroundColor: NSColor.white, .font: NSFont.preferredFont(forTextStyle: .title2)]))
    private let createUserButton = NSView()
    private var parentViewController: AppLoginViewControllerContract?
    private var containerScrollView = NSScrollView()
    
    func load(_ viewController: NSViewController) {
        
        guard let parentViewController = viewController as? AppLoginViewControllerContract else {
            return
        }
        
        self.parentViewController = parentViewController
        
        initializeDefaultValues()
        
        configureSelectUserLabel()
        
        configureUserStackView()
        
        fillUserStackView()
        
        configureCreateUserButton()
        
        configureContainerScrollView()
        
        addAllSubviews()
        
        addAllLayoutConstraints()
    }
    
    private func initializeDefaultValues() {
        userStackView = NSStackView()
        containerScrollView = NSScrollView()
    }
    
    private func configureSelectUserLabel() {
        selectUserLabel.font = NSFont.preferredFont(forTextStyle: .title1)
        selectUserLabel.textColor = .black
    }
    
    private func configureUserStackView() {
        userStackView.orientation = .vertical
        userStackView.wantsLayer = true
        userStackView.spacing = 5
    }
    
    private func fillUserStackView() {
        guard let parentViewController = parentViewController else {
            return
        }

        let success: ([User]) -> Void = {
            [weak self]
            (users) in
            self?.fillUserStackView(users: users)
            self?.setUserStackViewHeightConstraints()
        }
        
        let failure: (String) -> Void = {
            [weak self]
            (message: String) in
            print(message)
            let emptyUsersList: [User] = []
            self?.fillUserStackView(users: emptyUsersList)
        }
        parentViewController.getAllUsers(success: success, failure: failure)
    }
    
    private func setUserStackViewHeightConstraints() {
        if userStackView.views.count <= 5 {
            containerScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(userStackView.views.count * 55 - 5)).isActive = true
            containerScrollView.verticalScrollElasticity = .none
        } else {
            containerScrollView.heightAnchor.constraint(equalToConstant: 270).isActive = true
            containerScrollView.verticalScrollElasticity = .allowed
        }
    }
    
    private func fillUserStackView(users: [User]) {
        
        for user in users {
            let userView = GetViewForUser(user: user).getView()
            
            let mouseClickGesture = NSClickGestureRecognizer(target: self, action: #selector(SwitchUserView.changeLastLoggedInUser(_:)))
            userView.addGestureRecognizer(mouseClickGesture)
            
            userStackView.addArrangedSubview(userView)
            
        }
    }
    
    private func configureCreateUserButton() {
        let mouseClick = NSClickGestureRecognizer(target: self, action: #selector(createUser))
        
        
        createUserButton.wantsLayer = true
        createUserButton.layer?.backgroundColor = NSColor(red: 0, green: 0.8, blue: 0, alpha: 0.8).cgColor
        createUserButton.addGestureRecognizer(mouseClick)
        createUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createUserButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        createUserButton.layer?.cornerRadius = 20
        createUserButton.addSubview(createUserButtonText)
    }
    
    private func configureContainerScrollView() {
        containerScrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 50, height: 50))
        containerScrollView.documentView = userStackView
        containerScrollView.wantsLayer = true
        containerScrollView.drawsBackground = false
        containerScrollView.hasVerticalScroller = true
    }
    
    private func addAllSubviews() {
        subviews = [selectUserLabel, containerScrollView, createUserButton]
    }
    
    private func addAllLayoutConstraints() {
        createUserButtonText.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        selectUserLabel.translatesAutoresizingMaskIntoConstraints = false
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false

        setUserStackViewHeightConstraints()
        
        NSLayoutConstraint.activate([
            selectUserLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectUserLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 150),


            userStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            userStackView.widthAnchor.constraint(equalToConstant: 300),


            containerScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerScrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerScrollView.widthAnchor.constraint(equalToConstant: 300),


            createUserButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createUserButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150),
            createUserButtonText.centerYAnchor.constraint(equalTo: createUserButton.centerYAnchor),
            createUserButtonText.centerXAnchor.constraint(equalTo: createUserButton.centerXAnchor),
        ])
    }
    
    @objc func changeLastLoggedInUser(_ sender: NSClickGestureRecognizer) {
        guard let currentUserView = sender.view as? IndividualUserView else {
            return
        }
        
        guard let currentUser = currentUserView.user else {
            return
        }

        parentViewController?.setLastLoggedInUser(currentUser)
        
        if let parentViewController = parentViewController {
            parentViewController.changeViewToLogin()
        }
    }
    
    @objc func createUser() {
        parentViewController?.changeViewToRegistration()
    }
}

class IndividualUserView: NSVisualEffectView {
    var user: User?
}

class GetViewForUser {
    let userImage: NSImage?
    let username: String
    let user: User
    
    init(user: User) {
        self.user = user
        if let userImageURL = user.imageURL {
            self.userImage = NSImage.init(contentsOfFile: userImageURL.relativePath)
        } else {
            self.userImage = nil
        }
        self.username = user.username
    }
    
    func getView() -> NSView {
        let defaultImage = NSImage(named: "user_icon")!
        defaultImage.size = NSSize(width: 40, height: 40)
        
        let userImageView = NSImageView(image: userImage ?? defaultImage)
        userImageView.wantsLayer = true
        userImageView.layer?.cornerRadius = 15
        userImageView.imageScaling = NSImageScaling.scaleAxesIndependently
        
        let usernameView = NSTextField(labelWithString: username)
        usernameView.textColor = .black
        usernameView.lineBreakMode = .byTruncatingTail
        
        let userView = IndividualUserView(frame: NSRect(x: 0, y: 0, width: 300, height: 50))
        userView.user = user
        userView.material = .light
        userView.blendingMode = .withinWindow
        
        userView.subviews = [userImageView, usernameView]
        
        userView.wantsLayer = true
        
        userView.layer?.cornerRadius = 15
        
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            userImageView.leftAnchor.constraint(equalTo: userView.leftAnchor, constant: 5),
            userImageView.centerYAnchor.constraint(equalTo: userView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30),
            
            usernameView.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 5),
            usernameView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            usernameView.rightAnchor.constraint(equalTo: userView.rightAnchor, constant: -5),
            
            userView.heightAnchor.constraint(equalToConstant: 50),
            userView.widthAnchor.constraint(equalToConstant: 300),
        ])
        
        return userView
    }
    
}

