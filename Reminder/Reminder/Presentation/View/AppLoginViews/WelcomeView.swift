//
//  WelcomeView.swift
//  Reminder
//
//  Created by Arun Kumar on 22/02/22.
//

import Foundation
import AppKit

class WelcomeView: NSView, AppLoginViewContract {
    private let headline = NSTextField(labelWithString: "Welcome to Reminder!")
    private let subheadline = NSTextField(labelWithString: "To start, create user.")
    private let createUserButton = NSView()
    private let createUserButtonText = NSTextField(labelWithAttributedString: NSAttributedString(string: "Create User", attributes: [.foregroundColor: NSColor.white, .font: NSFont.preferredFont(forTextStyle: .title2)]))
    
    private var parentViewController: AppLoginViewControllerContract?
    
    func load(_ viewController: NSViewController) {
        
        guard let parentViewController = viewController as? AppLoginViewControllerContract else {
            return
        }
        
        self.parentViewController = parentViewController
        
        configureHeadline()
        
        configureSubheadline()
        
        configureCreateUserButton()
        
        addSubviews([headline, subheadline, createUserButton])
        
        addAllLayoutConstraints()
    }
    
    private func configureHeadline() {
        headline.font = NSFont.preferredFont(forTextStyle: .largeTitle)
        headline.textColor = .black
    }
    
    private func configureSubheadline() {
        subheadline.font = NSFont.preferredFont(forTextStyle: .title1)
        subheadline.textColor = .black
    }
    
    private func configureCreateUserButton() {
        createUserButton.wantsLayer = true
        createUserButton.layer?.backgroundColor = NSColor(red: 0, green: 0.8, blue: 0, alpha: 0.8).cgColor
        createUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createUserButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        createUserButton.layer?.cornerRadius = 20
        
        let mouseClick = NSClickGestureRecognizer(target: self, action: #selector(createUser))
        createUserButton.addGestureRecognizer(mouseClick)

        createUserButton.addSubview(createUserButtonText)
    }
    
    private func addAllLayoutConstraints() {
        headline.translatesAutoresizingMaskIntoConstraints = false
        subheadline.translatesAutoresizingMaskIntoConstraints = false
        createUserButtonText.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            headline.centerXAnchor.constraint(equalTo: centerXAnchor),
            headline.topAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            
            subheadline.centerXAnchor.constraint(equalTo: centerXAnchor),
            subheadline.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 50),
            
            createUserButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createUserButton.topAnchor.constraint(equalTo: subheadline.bottomAnchor, constant: 50),
            createUserButtonText.centerYAnchor.constraint(equalTo: createUserButton.centerYAnchor),
            createUserButtonText.centerXAnchor.constraint(equalTo: createUserButton.centerXAnchor),
        ])
    }
    
    private func addSubviews(_ views: [NSView]) {
        subviews = views
    }
    
    @objc func createUser() {
        parentViewController?.changeViewToRegistration()
    }
}


