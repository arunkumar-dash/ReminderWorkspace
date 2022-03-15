//
//  RegistrationViewController.swift
//  Reminder
//
//  Created by Arun Kumar on 18/02/22.
//

import Foundation
import AppKit

class RegistrationView: NSView, AppLoginViewContract {
    
    var usernameTextBox = NSTextField()
    var passwordTextBox = NSSecureTextField()
    
    var userImageView = NSImageView(image: NSImage(named: "user_icon")!)
    var userImageURL: URL? = nil
    var responseLabel: NSTextField = NSTextField(labelWithString: "")
    private let addButtonImage = NSImageView(image: NSImage(named: "plus_sign")!)
    private let navigateNextButton = NSImageView(image: NSImage(named: "right_arrow")!)
    private let navigateBackButton = NSImageView(image: NSImage(named: "left_arrow")!)
    private var parentViewController: AppLoginViewControllerContract?
    private var usernameStringValue = ""
    private var passwordStringValue = ""
    
    
    func load(_ viewController: NSViewController) {
        
        initializeDefaultValues()
        
        guard let parentViewController = viewController as? AppLoginViewControllerContract else {
            return
        }
        
        self.parentViewController = parentViewController
        
        configureUserImageView()
        
        configureNavigateBackButton()
        
        configureNavigateNextButton()
        
        configureUsernameTextBox()
        
        configurePasswordTextBox()
        
        configureResponseLabel()
        
        addSubviews([userImageView, usernameTextBox, passwordTextBox, responseLabel, navigateBackButton, addButtonImage, navigateNextButton])
        
        
        setFirstResponder()
        
        addAllLayoutConstraints()
    }
    
    private func initializeDefaultValues() {
        usernameTextBox = NSTextField()
        passwordTextBox = NSSecureTextField()
        userImageView = NSImageView(image: NSImage(named: "user_icon")!)
        responseLabel = NSTextField(labelWithString: "")
        usernameStringValue = ""
        passwordStringValue = ""
    }
    
    private func configureUserImageView() {
        self.userImageView.image?.size = NSSize(width: 200, height: 200)
        userImageView.wantsLayer = true
        userImageView.layer?.cornerRadius = 100
        userImageView.imageScaling = NSImageScaling.scaleAxesIndependently
        
        /// adding points manually as `userImageView.frame` is set after constraints are set
        addTrackingArea(NSTrackingArea(rect: NSRect(origin: CGPoint(x: 200, y: 370), size: CGSize(width: 200, height: 200)), options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp], owner: self))
    
        let mouseClickToAddImageInUserImage = NSClickGestureRecognizer(target: self, action: #selector(getUserImage))
        userImageView.addGestureRecognizer(mouseClickToAddImageInUserImage)
        
        let mouseClickToAddImage = NSClickGestureRecognizer(target: self, action: #selector(getUserImage))
        addButtonImage.image?.size = NSSize(width: 50, height: 50)
        addButtonImage.isHidden = true
        addButtonImage.addGestureRecognizer(mouseClickToAddImage)
    }
    
    private func configureNavigateBackButton() {
        navigateBackButton.image?.size = NSSize(width: 20, height: 20)
        navigateBackButton.wantsLayer = true
        navigateBackButton.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        navigateBackButton.layer?.cornerRadius = 15
        
        let mouseClickOverNavigateButton = NSClickGestureRecognizer(target: self, action: #selector(navigateBack))
        
        navigateBackButton.addGestureRecognizer(mouseClickOverNavigateButton)
    }
    
    private func configureNavigateNextButton() {
        navigateNextButton.image?.size = NSSize(width: 20, height: 20)
        navigateNextButton.wantsLayer = true
        navigateNextButton.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        navigateNextButton.layer?.cornerRadius = 15
        
        let mouseClickOverNavigateNextButton = NSClickGestureRecognizer(target: self, action: #selector(createUser))
        
        navigateNextButton.addGestureRecognizer(mouseClickOverNavigateNextButton)
        
        navigateNextButton.isHidden = true
    }
    
    private func configureUsernameTextBox() {
        usernameTextBox.placeholderString = "User Name"
        usernameTextBox.placeholderAttributedString = NSAttributedString(string: "User Name", attributes: [.foregroundColor: NSColor.init(white: 1, alpha: 0.5), .font: NSFont.preferredFont(forTextStyle: .title3)])
        usernameTextBox.textColor = .white
        usernameTextBox.font = .preferredFont(forTextStyle: .title3)
        usernameTextBox.alignment = .left
        usernameTextBox.focusRingType = .none
        usernameTextBox.lineBreakMode = .byTruncatingTail
        usernameTextBox.bezelStyle = .roundedBezel
        usernameTextBox.wantsLayer = true
        usernameTextBox.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        usernameTextBox.layer?.cornerRadius = 15
    }
    
    private func configurePasswordTextBox() {
        passwordTextBox.placeholderString = "Password"
        passwordTextBox.placeholderAttributedString = NSAttributedString(string: "Password", attributes: [.foregroundColor: NSColor.init(white: 1, alpha: 0.5), .font: NSFont.preferredFont(forTextStyle: .title3)])
        passwordTextBox.textColor = .white
        passwordTextBox.font = .preferredFont(forTextStyle: .title3)
        passwordTextBox.alignment = .left
        passwordTextBox.focusRingType = .none
        passwordTextBox.lineBreakMode = .byTruncatingTail
        passwordTextBox.bezelStyle = .roundedBezel
        passwordTextBox.wantsLayer = true
        passwordTextBox.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        passwordTextBox.layer?.cornerRadius = 15
    }
    
    private func configureResponseLabel() {
        responseLabel.isHidden = true
    }
    
    private func addSubviews(_ views: [NSView]) {
        subviews = views
    }
    
    private func addAllLayoutConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextBox.translatesAutoresizingMaskIntoConstraints = false
        passwordTextBox.translatesAutoresizingMaskIntoConstraints = false
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        navigateBackButton.translatesAutoresizingMaskIntoConstraints = false
        navigateNextButton.translatesAutoresizingMaskIntoConstraints = false
        addButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameTextBox.topAnchor.constraint(equalTo: centerYAnchor),
            usernameTextBox.widthAnchor.constraint(equalToConstant: 250),
            usernameTextBox.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            passwordTextBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextBox.topAnchor.constraint(equalTo: usernameTextBox.bottomAnchor, constant: 20),
            passwordTextBox.widthAnchor.constraint(equalToConstant: 250),
            passwordTextBox.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            navigateBackButton.heightAnchor.constraint(equalToConstant: 30),
            navigateBackButton.widthAnchor.constraint(equalToConstant: 30),
            navigateBackButton.centerYAnchor.constraint(equalTo: passwordTextBox.centerYAnchor),
            navigateBackButton.rightAnchor.constraint(equalTo: passwordTextBox.leftAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            navigateNextButton.heightAnchor.constraint(equalToConstant: 30),
            navigateNextButton.widthAnchor.constraint(equalToConstant: 30),
            navigateNextButton.centerYAnchor.constraint(equalTo: passwordTextBox.centerYAnchor),
            navigateNextButton.leftAnchor.constraint(equalTo: passwordTextBox.rightAnchor, constant: 10),
        ])
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            userImageView.heightAnchor.constraint(equalToConstant: 200),
            userImageView.widthAnchor.constraint(equalToConstant: 200),
            
            responseLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            responseLabel.topAnchor.constraint(equalTo: passwordTextBox.bottomAnchor, constant: 10),
            
            addButtonImage.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            addButtonImage.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setFirstResponder() {
        window?.makeFirstResponder(self.usernameTextBox)
    }
    
    @objc func createUser() {
        parentViewController?.createUser(self)
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
    
    override func keyUp(with event: NSEvent) {
        let RETURN_KEY_CODE = 36
        let TAB_KEY_CODE = 48
        unhideAnimationView(self.navigateNextButton)
        if (event.keyCode == RETURN_KEY_CODE) && (usernameTextBox.stringValue != usernameStringValue) {
            usernameStringValue = usernameTextBox.stringValue
            self.passwordTextBox.setAccessibilityFocused(true)
        } else if (event.keyCode == RETURN_KEY_CODE) && (passwordTextBox.stringValue != passwordStringValue) {
            passwordStringValue = passwordTextBox.stringValue
            createUser()
        } else if (event.keyCode == TAB_KEY_CODE) && (usernameTextBox.stringValue != usernameStringValue) {
            usernameStringValue = usernameTextBox.stringValue
            self.passwordTextBox.setAccessibilityFocused(true)
        } else if (event.keyCode == TAB_KEY_CODE) && (passwordTextBox.stringValue != passwordStringValue) {
            passwordStringValue = passwordTextBox.stringValue
            self.usernameTextBox.setAccessibilityFocused(true)
        }
    }
    
    @objc func navigateBack() {
        parentViewController?.navigateBackToPreviousView()
    }
    
    @objc func getUserImage() {
        defer {
            addButtonImage.isHidden = true
        }
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.isOpaque = false
        panel.hidesOnDeactivate = true
//        panel.allowedFileTypes = ["jpg", "jpeg", "png", "tiff", "qtif", "pict"]
        panel.allowsMultipleSelection = false
        
        guard panel.runModal() == .OK, let imageURL = panel.url else { return }
        
        if let userImage = NSImage(contentsOfFile: imageURL.relativePath) {
            self.userImageView.image = userImage
            self.userImageView.needsDisplay = true
            self.userImageURL = imageURL
        } else {
            print("Invalid format")
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if userImageView.frame.contains(event.locationInWindow) {
            addButtonImage.isHidden = false
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if userImageView.frame.contains(event.locationInWindow) == false {
            addButtonImage.isHidden = true
        }
    }
}

