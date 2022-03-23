//
//  CreateReminderView.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit

class CreateReminderView: NSView, NSTextViewDelegate {
    private var profilePhotoView: NSImageView = NSImageView(image: NSImage(named: "user_icon")!)
    private var datePickerButton: NSView = NSView()
    private var popOverDatePicker: NSPopover = NSPopover()
    // internal access control because it is modified in edit reminder view
    var titleTextBox: NSTextField = NSTextField()
    var datePicker: NSDatePicker = NSDatePicker()
    var descriptionTextBox: NSScrollView = NSScrollView()
    var responseLabel: NSTextField = NSTextField()
    private var cancelButton: NSView = NSView()
    private var saveButton: NSView = NSView()
    private var dashboardViewController: DashboardViewControllerContract?
    private var profileMenu: NSMenu = NSMenu()
    
    deinit {
        print("create remidner view deinit")
    }
    
    func load(_ parentViewController: NSViewController) {
        guard let dashboardViewController = parentViewController as? DashboardViewControllerContract else {
            return
        }
        
        self.dashboardViewController = dashboardViewController
        load()
        wantsLayer = true
        layer?.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.25)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 260).isActive = true
        widthAnchor.constraint(equalTo: parentViewController.view.widthAnchor, multiplier: 0.33).isActive = true
//        widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let success: (URL?) -> Void = {
            [weak self]
            (imageURL: URL?) in
            self?.setUserImage(imageURL: imageURL)
        }
        
        let failure = {
            (message: String) in
            print(message)
        }
        
        dashboardViewController.getLastLoggedInUserImageURL(success: success, failure: failure)
        
    }
    
    private func load() {
        configureProfilePhotoView()
        configureProfilePhotoMenu()
        configureTitleTextBox()
        configureDatePickerButton()
        configureDescriptionTextBox()
        configureResponseLabel()
        configureCancelButton()
        configureSaveButton()
        addAllSubViews()
        addAllLayoutConstraints()
    }
    
    private func setUserImage(imageURL: URL?) {
        if let imageURL = imageURL {
            if let profileImage = NSImage(contentsOfFile: imageURL.relativePath) {
                profilePhotoView.image = profileImage
                print(imageURL)
            }
        }
    }
    
    private func configureProfilePhotoView() {
        
        profilePhotoView.wantsLayer = true
        profilePhotoView.layer?.cornerRadius = 15
        profilePhotoView.imageScaling = NSImageScaling.scaleAxesIndependently
        
        let mouseClickOnProfilePhoto = NSClickGestureRecognizer(target: self, action: #selector(showProfileOptions))
        profilePhotoView.addGestureRecognizer(mouseClickOnProfilePhoto)
        
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        
        profilePhotoView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profilePhotoView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configureProfilePhotoMenu() {
        profileMenu = NSMenu(title: "Profile")
        profileMenu.autoenablesItems = false
        let preferences = NSMenuItem(title: "Preferences...", action: #selector(openPreferencesWindow), keyEquivalent: "preferences")
        preferences.menu?.autoenablesItems = false
        preferences.isEnabled = false
        let logOut = NSMenuItem(title: "Log Out", action: #selector(LogOut), keyEquivalent: "log out")
        profileMenu.addItem(preferences)
        profileMenu.addItem(logOut)
    }
    
    @objc func openPreferencesWindow() {
        print("open preferences menu")
    }
    
    @objc func LogOut() {
        dashboardViewController?.changeViewToLogin()
    }
    
    @objc func showProfileOptions() {
        profileMenu.popUp(positioning: nil, at: profilePhotoView.frame.origin, in: self)
    }
    
    private func configureTitleTextBox() {
        titleTextBox.placeholderString = "Enter Title"
        titleTextBox.placeholderAttributedString = NSAttributedString(string: "Enter Title", attributes: [.foregroundColor: NSColor.init(white: 1, alpha: 0.5), .font: NSFont.preferredFont(forTextStyle: .title3)])
        titleTextBox.textColor = .white
        titleTextBox.font = .preferredFont(forTextStyle: .title3)
        titleTextBox.alignment = .left
        titleTextBox.focusRingType = .none
        titleTextBox.lineBreakMode = .byTruncatingTail
        titleTextBox.bezelStyle = .roundedBezel
        titleTextBox.wantsLayer = true
        titleTextBox.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        titleTextBox.layer?.cornerRadius = 5
        
        titleTextBox.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTextBox.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    }
    
    private func configureDatePickerButton() {
        configureDatePicker()
        popOverDatePicker.contentViewController = NSViewController()
        popOverDatePicker.contentViewController?.view = datePicker
        popOverDatePicker.behavior = .transient
        popOverDatePicker.contentSize = datePicker.fittingSize
        
        datePickerButton = NSImageView(image: NSImage(named: "calendar")!)
        let mouseClickOnDatePicker = NSClickGestureRecognizer(target: self, action: #selector(showPopOverDatePicker))
        datePickerButton.addGestureRecognizer(mouseClickOnDatePicker)
        datePickerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func showPopOverDatePicker() {
        popOverDatePicker.show(relativeTo: datePickerButton.frame, of: self, preferredEdge: .minY)
    }
    
    private func configureDatePicker() {
        let datePicker = NSDatePicker()
        datePicker.wantsLayer = true
        datePicker.datePickerStyle = .textFieldAndStepper
        datePicker.textColor = .white
        datePicker.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.datePicker = datePicker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.layer?.cornerRadius = 5
        datePicker.timeZone = .current
        datePicker.presentsCalendarOverlay = true
        datePicker.layer?.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.25)
        datePicker.dateValue = Date.now.addingTimeInterval(3600)
        datePicker.minDate = Date.now.addingTimeInterval(60) // handle current date when user selects the date
    }
    
    private func configureDescriptionTextBox() {
        descriptionTextBox = NSTextView.scrollableTextView()
        descriptionTextBox.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextBox.drawsBackground = false
        descriptionTextBox.wantsLayer = true
        descriptionTextBox.layer?.cornerRadius = 5
        descriptionTextBox.verticalScrollElasticity = .none
        descriptionTextBox.hasVerticalScroller = true
        let textView = descriptionTextBox.documentView as? NSTextView
        textView?.isEditable = true
        textView?.wantsLayer = true
        textView?.layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        textView?.drawsBackground = false
        textView?.font = .preferredFont(forTextStyle: .title3)
        textView?.string = "Enter Description"
        textView?.textColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
        textView?.delegate = self
        textView?.textContainerInset = NSSize(width: 5, height: 5)
    }
    
    private func configureResponseLabel() {
        responseLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: "", attributes: [.foregroundColor: NSColor.green]))
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textDidChange(_ notification: Notification) {
        guard let textView = descriptionTextBox.documentView as? NSTextView else {
            return
        }
        if textView.string.starts(with: "Enter Description") && textView.textColor == .init(red: 1, green: 1, blue: 1, alpha: 0.5) {
            textView.string = String(textView.string[textView.string.index(textView.string.startIndex, offsetBy: 17)...])
            textView.textColor = .white
        } else {
            textView.textColor = .white
        }
    }
    
    private func configureCancelButton() {
        let mouseClick = NSClickGestureRecognizer(target: self, action: #selector(cancel))
        
        cancelButton.addGestureRecognizer(mouseClick)
        let cancelButtonText = NSTextField(labelWithAttributedString: NSAttributedString(string: "Cancel", attributes: [.foregroundColor: NSColor.white, .font: NSFont.preferredFont(forTextStyle: .title3)]))
        
        cancelButton.wantsLayer = true
        cancelButton.layer?.backgroundColor = NSColor(red: 0.8, green: 0, blue: 0, alpha: 0.8).cgColor
        cancelButton.layer?.cornerRadius = 15
        cancelButton.addSubview(cancelButtonText)
        cancelButtonText.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonText.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        cancelButtonText.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor).isActive = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 115).isActive = true
    }
    
    @objc func cancel() {
        print("clear entries")
        clearEntries()
        resetFirstResponder()
    }
    
    private func clearEntries() {
        resetTitleTextBox()
        resetDescriptionTextBox()
        resetDatePicker()
    }
    
    private func resetTitleTextBox() {
        titleTextBox.stringValue = ""
    }
    
    private func resetDatePicker() {
        datePicker.dateValue = Date.now.addingTimeInterval(3600)
    }
    
    private func resetDescriptionTextBox() {
        let textView = descriptionTextBox.documentView as? NSTextView
        textView?.string = "Enter Description"
        textView?.textColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    private func resetFirstResponder() {
        titleTextBox.becomeFirstResponder()
    }
    
    private func configureSaveButton() {
        
        let mouseClick = NSClickGestureRecognizer(target: self, action: #selector(save))
        
        saveButton.addGestureRecognizer(mouseClick)
        let saveButtonText = NSTextField(labelWithAttributedString: NSAttributedString(string: "Save", attributes: [.foregroundColor: NSColor.white, .font: NSFont.preferredFont(forTextStyle: .title3)]))
        saveButton.wantsLayer = true
        saveButton.layer?.backgroundColor = NSColor(red: 0, green: 0.8, blue: 0, alpha: 0.8).cgColor
        saveButton.layer?.cornerRadius = 15
        saveButton.addSubview(saveButtonText)
        saveButtonText.translatesAutoresizingMaskIntoConstraints = false
        saveButtonText.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).isActive = true
        saveButtonText.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor).isActive = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 115).isActive = true
    }
    
    @objc func save() {
        print("Add entries to database")
        let title = titleTextBox.stringValue
        var description = ""
        let date = datePicker.dateValue
        print("Title:", titleTextBox.stringValue)
        if let textView = descriptionTextBox.documentView as? NSTextView {
            print("Description:", textView.string)
            description = textView.string
        }
        print("Date:", datePicker.dateValue)
        
        
        dashboardViewController?.addReminder(title: title, description: description, date: date, success: {
            [weak self]
            in
            self?.responseLabel.stringValue = "Reminder Created!"
            self?.responseLabel.textColor = .systemGreen
            self?.responseLabel.font = NSFont.preferredFont(forTextStyle: .title2)
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 5
            shadow.shadowColor = .white
            self?.responseLabel.shadow = shadow
        }, failure: {
            [weak self]
            (message: String)
            in
            self?.responseLabel.stringValue = message
            self?.responseLabel.textColor = .systemRed
            self?.responseLabel.font = NSFont.preferredFont(forTextStyle: .title2)
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 5
            shadow.shadowColor = .white
            self?.responseLabel.shadow = shadow
        })
    }
    
    private func addAllSubViews() {
        subviews = [profilePhotoView, titleTextBox, datePickerButton, descriptionTextBox, responseLabel, saveButton, cancelButton]
    }
    
    private func addAllLayoutConstraints() {
        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            profilePhotoView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            
            titleTextBox.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: 20),
            titleTextBox.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            
            datePickerButton.leftAnchor.constraint(equalTo: titleTextBox.rightAnchor, constant: 5),
            datePickerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            datePickerButton.centerYAnchor.constraint(equalTo: titleTextBox.centerYAnchor),
            datePickerButton.heightAnchor.constraint(equalTo: titleTextBox.heightAnchor),
            datePickerButton.widthAnchor.constraint(equalTo: datePickerButton.heightAnchor),
            
            descriptionTextBox.topAnchor.constraint(equalTo: titleTextBox.bottomAnchor, constant: 5),
            descriptionTextBox.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            descriptionTextBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            descriptionTextBox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            responseLabel.topAnchor.constraint(equalTo: descriptionTextBox.bottomAnchor, constant: 5),
            responseLabel.centerXAnchor.constraint(equalTo: descriptionTextBox.centerXAnchor),
            
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            
            cancelButton.rightAnchor.constraint(equalTo: saveButton.leftAnchor, constant: -10),
            cancelButton.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 5),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
        ])
    }
}
