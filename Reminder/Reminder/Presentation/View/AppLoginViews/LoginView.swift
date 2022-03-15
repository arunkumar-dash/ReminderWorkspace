//
//  LoginView.swift
//  Reminder
//
//  Created by Arun Kumar on 18/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class LoginView: NSView, NSGestureRecognizerDelegate, AppLoginViewContract {
    private var username = NSTextField()
    private var userImage = NSImageView()
    var passwordTextBox = NSSecureTextField()
    private let enterPasswordLabel = NSTextField(labelWithString: "Enter Password")
    private let incorrectPasswordLabel = NSTextField(labelWithString: "Incorrect password")
    private var parentViewController: AppLoginViewControllerContract?
    private let navigateNextButton = NSImageView(image: NSImage(named: "right_arrow")!)
    private let switchUserButton = NSView()
    private var lastLoggedInUser: User? = nil
    
    
    func load(_ viewController: NSViewController) {
        initializeDefaultValues()
        
        guard let parentViewController = viewController as? AppLoginViewControllerContract else {
            return
        }
        
        self.parentViewController = parentViewController
        
        configureSwitchUserButton()
        
        let success: (User) -> Void = {
            [weak self]
            (user) in
            self?.lastLoggedInUser = user
            
            self?.configureUsernameTextBox()
            
            self?.configureUserImage()
            
            self?.addAllSubviews()
            
            self?.addAllLayoutConstraints()
            
            self?.setFirstResponderAsPasswordTextBox()
        }
        
        let failure = {
            (message: String) in
            print(message)
        }
        
        parentViewController.getLastLoggedInUser(success: success, failure: failure)
        
        configurePasswordTextBox()
        
        configureNavigateNextButton()
        
        configureEnterPasswordLabel()
        
        configureIncorrectPasswordLabel()
        
        
        let mouseClick = NSClickGestureRecognizer(target: self, action: #selector(getPassword))
        addGestureRecognizer(mouseClick)
        
    }
    
    private func initializeDefaultValues() {
        passwordTextBox.stringValue = ""
    }
    
    private func setFirstResponderAsPasswordTextBox() {
        self.window?.makeFirstResponder(self.passwordTextBox)
    }
    
    private func unhideAnimationView(_ view: NSView) {
        guard view.isHidden else { return }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = view.layer?.opacity
        animation.duration = 0.5
        view.isHidden = false
        view.layer?.add(animation, forKey: nil)
    }
    
    private func configureSwitchUserButton() {
        let switchUserImageView = NSImageView(image: NSImage(named: "user_icon1")!)
        switchUserImageView.image?.size = NSSize(width: 20, height: 20)
        switchUserImageView.wantsLayer = true
        switchUserImageView.layer?.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.25)
        switchUserImageView.layer?.cornerRadius = 15
        
        let mouseClickOverSwitchUserButton = NSClickGestureRecognizer(target: self, action: #selector(navigateToSwitchUserView))
        
        switchUserButton.addGestureRecognizer(mouseClickOverSwitchUserButton)
        
        switchUserButton.addSubview(switchUserImageView)
        
        let switchUserLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: "Switch User", attributes: [.font: NSFont.preferredFont(forTextStyle: .footnote), .foregroundColor: NSColor.white]))
        switchUserButton.addSubview(switchUserLabel)
        
        switchUserImageView.translatesAutoresizingMaskIntoConstraints = false
        switchUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchUserImageView.heightAnchor.constraint(equalToConstant: 30),
            switchUserImageView.widthAnchor.constraint(equalToConstant: 30),
            switchUserImageView.centerXAnchor.constraint(equalTo: switchUserButton.centerXAnchor),
            switchUserImageView.topAnchor.constraint(equalTo: switchUserButton.topAnchor),
            
            switchUserLabel.topAnchor.constraint(equalTo: switchUserImageView.bottomAnchor, constant: 5),
            switchUserLabel.centerXAnchor.constraint(equalTo: switchUserButton.centerXAnchor),
        ])
    }
    
    private func configureUsernameTextBox() {
        guard let lastLoggedInUser = lastLoggedInUser else {
            return
        }
        
        self.username = NSTextField(labelWithAttributedString: NSAttributedString(string: lastLoggedInUser.username, attributes: [.font: NSFont.preferredFont(forTextStyle: .largeTitle), .foregroundColor: NSColor.white]))
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 1
        shadow.shadowColor = .black
        username.shadow = shadow
    }
    
    private func configurePasswordTextBox() {
        passwordTextBox.placeholderString = "Enter password"
        passwordTextBox.placeholderAttributedString = NSAttributedString(string: "Enter password", attributes: [.foregroundColor: NSColor.init(white: 1, alpha: 0.5), .font: NSFont.preferredFont(forTextStyle: .title3)])
        passwordTextBox.isHidden = true
        passwordTextBox.textColor = .white
        passwordTextBox.font = .preferredFont(forTextStyle: .title3)
        passwordTextBox.alignment = .left
        passwordTextBox.focusRingType = .none
        passwordTextBox.lineBreakMode = .byTruncatingHead
        passwordTextBox.bezelStyle = .roundedBezel
        passwordTextBox.wantsLayer = true
        passwordTextBox.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        passwordTextBox.layer?.cornerRadius = 15
    }
    
    private func configureNavigateNextButton() {
        navigateNextButton.image?.size = NSSize(width: 20, height: 20)
        navigateNextButton.wantsLayer = true
        navigateNextButton.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        navigateNextButton.layer?.cornerRadius = 15
        
        let mouseClickOverNavigateNextButton = NSClickGestureRecognizer(target: self, action: #selector(validatePassword))
        navigateNextButton.addGestureRecognizer(mouseClickOverNavigateNextButton)
        
        navigateNextButton.isHidden = true
    }
    
    private func configureEnterPasswordLabel() {
        enterPasswordLabel.alphaValue = 1
        enterPasswordLabel.font = NSFont.preferredFont(forTextStyle: .title3)
        enterPasswordLabel.textColor = .white
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowColor = .black
        enterPasswordLabel.shadow = shadow
    }
    
    private func configureIncorrectPasswordLabel() {
        incorrectPasswordLabel.isHidden = true
        incorrectPasswordLabel.font = NSFont.preferredFont(forTextStyle: .footnote)
        incorrectPasswordLabel.textColor = .red
    }
    
    private func configureUserImage() {
        guard let lastLoggedInUser = lastLoggedInUser else {
            return
        }
        
        let defaultImage = NSImage(named: "user_icon")!
        defaultImage.size = NSSize(width: 200, height: 200)
        
        self.userImage = NSImageView(image: defaultImage)
        
        if let imageURL = lastLoggedInUser.imageURL {
            self.userImage = NSImageView(image: NSImage(contentsOfFile: imageURL.relativePath) ?? defaultImage)
        }
        
        userImage.wantsLayer = true
        userImage.layer?.cornerRadius = 100
        userImage.imageScaling = NSImageScaling.scaleAxesIndependently
    }
    
    private func addAllSubviews() {
        subviews = [userImage, username, passwordTextBox, incorrectPasswordLabel, navigateNextButton, enterPasswordLabel, switchUserButton]
    }
    
    private func addAllLayoutConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        passwordTextBox.translatesAutoresizingMaskIntoConstraints = false
        incorrectPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        navigateNextButton.translatesAutoresizingMaskIntoConstraints = false
        enterPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        switchUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            userImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            userImage.heightAnchor.constraint(equalToConstant: 200),
            userImage.widthAnchor.constraint(equalToConstant: 200),
            
            username.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            username.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
            
            passwordTextBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextBox.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 50),
            passwordTextBox.widthAnchor.constraint(equalToConstant: 250),
            passwordTextBox.heightAnchor.constraint(equalToConstant: 30),
            
            enterPasswordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            enterPasswordLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 50),
            
            navigateNextButton.heightAnchor.constraint(equalToConstant: 30),
            navigateNextButton.widthAnchor.constraint(equalToConstant: 30),
            navigateNextButton.centerYAnchor.constraint(equalTo: passwordTextBox.centerYAnchor),
            navigateNextButton.leftAnchor.constraint(equalTo: passwordTextBox.rightAnchor, constant: 10),
            
            incorrectPasswordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            incorrectPasswordLabel.topAnchor.constraint(equalTo: passwordTextBox.bottomAnchor, constant: 20),
            
            switchUserButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            switchUserButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            switchUserButton.heightAnchor.constraint(equalToConstant: 50),
            switchUserButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    @objc func getPassword() {
        setFirstResponderAsPasswordTextBox()
        showPasswordOptions()
    }
    
    func showPasswordOptions() {
        if self.enterPasswordLabel.alphaValue > 0 {
            self.enterPasswordLabel.alphaValue = 0
        }
        if self.passwordTextBox.isHidden {
            unhideAnimationView(self.passwordTextBox)
        }
        if self.navigateNextButton.isHidden {
            unhideAnimationView(self.navigateNextButton)
        }
    }
    
    @objc func validatePassword() {
        if passwordTextBox.stringValue.count == 0 {
            return
        }
        print("password:", passwordTextBox.stringValue)
        
        if lastLoggedInUser?.password == passwordTextBox.stringValue {
            //log in
            print("logged in")
            incorrectPasswordLabel.isHidden = true
            
            // dashboard view
        } else {
            incorrectPasswordLabel.isHidden = false
        }
    }
    
    
    // submit on pressing return key
    override func keyUp(with event: NSEvent) {
        showPasswordOptions()
        let RETURN_KEY_CODE = 36
        if event.keyCode == RETURN_KEY_CODE {
            validatePassword()
        }
    }
    
    @objc func navigateToSwitchUserView() {
        self.parentViewController?.changeViewToSwitchUser()
    }
}
