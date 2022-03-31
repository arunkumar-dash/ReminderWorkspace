//
//  EditReminderView.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class EditReminderView: NSView, NSTextViewDelegate {
    private var profilePhotoView: NSImageView = NSImageView(image: NSImage(named: "user_icon")!)
    private var datePickerButton: NSView = NSView()
    private var popOverDatePicker: NSPopover = NSPopover()
    private var titleTextBox: NSTextField = NSTextField()
    private var datePicker: NSDatePicker = NSDatePicker()
    private var descriptionTextView: NSScrollView = NSScrollView()
    private var repeatPatternView = NSView()
    private let repeatPatternButton = NSPopUpButton()
    private var repeatPatternValue: RepeatPattern = .never
    private var responseLabel: NSTextField = NSTextField()
    private var cancelButton: NSView = NSView()
    private var saveButton: NSView = NSView()
    private var dashboardViewController: DashboardViewControllerContract?
    private var profileMenu: NSMenu = NSMenu()
    private var currentReminder: Reminder?
    private var success: ((Reminder) -> Void)?
    
    func load(_ parentViewController: NSViewController, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (String) -> Void) {
        guard let dashboardViewController = parentViewController as? DashboardViewControllerContract else {
            return
        }
        self.success = success
        self.dashboardViewController = dashboardViewController
        self.currentReminder = reminder
        load()
        setBackgroundColor()
        setLayoutConstraints()
        setProfileImage()
        fillValues()
    }
    
    private func fillValues() {
        guard let currentReminder = currentReminder else {
            return
        }

        // setTitle()
        self.titleTextBox.stringValue = currentReminder.title
        // setDescription()
        (self.descriptionTextView.documentView as? NSTextView)?.string = currentReminder.description
//        setDatePicker()
//        setRepeatPattern()
        
        
    }
    
    private func setProfileImage() {
        let success: (URL?) -> Void = {
            [weak self]
            (imageURL: URL?) in
            self?.setUserImage(imageURL: imageURL)
        }
        
        let failure = {
            (message: String) in
            print(message)
        }
        
        dashboardViewController?.getLastLoggedInUserImageURL(success: success, failure: failure)
    }
    
    private func setBackgroundColor() {
        wantsLayer = true
        layer?.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.25)
    }
    
    private func setLayoutConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 260).isActive = true
    }
    
    private func load() {
        configureProfilePhotoView()
        configureProfilePhotoMenu()
        configureTitleTextBox()
        configureDatePickerButton()
        configureDescriptionTextBox()
        configureRepeatPatternView()
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
        descriptionTextView = NSTextView.scrollableTextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.drawsBackground = false
        descriptionTextView.wantsLayer = true
        descriptionTextView.layer?.cornerRadius = 5
        descriptionTextView.verticalScrollElasticity = .none
        descriptionTextView.hasVerticalScroller = true
        let textView = descriptionTextView.documentView as? NSTextView
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
    
    private func configureRepeatPatternView() {
        
        // have a variable to store repeat pattern, change it on clicking menuitem in popupbutton
        // repeatPatternButton is a view consisting of a label to the left and a popup button to the right
        // popup button should have pullDown to false
        // configure each menuitem in a loop by changing its view property
        // change view color of selected menuitem
        // use separate functions
        let repeatPatternLabel = NSTextField(labelWithString: "Repeat Pattern")
        repeatPatternLabel.translatesAutoresizingMaskIntoConstraints = false
        let repeatPatternButtonCell = repeatPatternButton.cell as? NSPopUpButtonCell
        repeatPatternButtonCell?.menu = getRepeatPatternMenu()
        repeatPatternButton.translatesAutoresizingMaskIntoConstraints = false
        repeatPatternView.addSubview(repeatPatternLabel)
        repeatPatternView.addSubview(repeatPatternButton)
        repeatPatternView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatPatternLabel.rightAnchor.constraint(equalTo: repeatPatternView.centerXAnchor, constant: -5),
            repeatPatternLabel.centerYAnchor.constraint(equalTo: repeatPatternView.centerYAnchor),
            
            repeatPatternButton.leftAnchor.constraint(equalTo: repeatPatternView.centerXAnchor, constant: 5),
            repeatPatternButton.centerYAnchor.constraint(equalTo: repeatPatternView.centerYAnchor),
            
            repeatPatternView.heightAnchor.constraint(equalToConstant: 30),
            repeatPatternView.widthAnchor.constraint(greaterThanOrEqualToConstant: 230),
        ])
    }
    
    private func getRepeatPatternMenu() -> NSMenu {
        let menu = NSMenu(title: "Repeat Pattern")
        
        for item in ["Never", "Every Minute", "Every Day", "Every Week", "Every Month", "Every Year"] {
            menu.addItem(getRepeatPatternMenuItem(title: item))
        }
        
        return menu
    }
    
    
    private func getRepeatPatternMenuItem(title: String) -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.action = #selector(changeRepeatPatternMenuTitleToSelectedItem)
//        menuItem.view = getMenuView(title: title)
        menuItem.title = title
        return menuItem
    }
    
    
    @objc func changeRepeatPatternMenuTitleToSelectedItem() {
        let index = repeatPatternButton.indexOfSelectedItem
        let item = repeatPatternButton.item(at: index)
        if let title = item?.title {
            switch(title) {
            case "Never":
                repeatPatternValue = .never
            case "Every Minute":
                repeatPatternValue = .everyMinute
            case "Every Day":
                repeatPatternValue = .everyDay
            case "Every Week":
                repeatPatternValue = .everyWeek
            case "Every Month":
                repeatPatternValue = .everyMonth
            case "Every Year":
                repeatPatternValue = .everyYear
            default:
                repeatPatternValue = .never
            }
            repeatPatternButton.title = title
        }
    }
    
    private func configureResponseLabel() {
        responseLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: "", attributes: [.foregroundColor: NSColor.green]))
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textDidChange(_ notification: Notification) {
        guard let textView = descriptionTextView.documentView as? NSTextView else {
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
//        resetFirstResponder()
    }
    
    private func clearEntries() {
        resetTitleTextBox()
        resetDescriptionTextBox()
        resetDatePicker()
        resetRepeatPatternView()
    }
    
    private func resetTitleTextBox() {
        titleTextBox.stringValue = ""
    }
    
    private func resetDatePicker() {
        datePicker.dateValue = Date.now.addingTimeInterval(3600)
    }
    
    private func resetDescriptionTextBox() {
        let textView = descriptionTextView.documentView as? NSTextView
        textView?.string = "Enter Description"
        textView?.textColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    private func resetRepeatPatternView() {
        repeatPatternButton.selectItem(withTitle: "Never")
        repeatPatternButton.title = "Never"
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
        guard titleTextBox.stringValue.count > 0 else { return }
        print("Edited database")
        let title = titleTextBox.stringValue
        var description = ""
        let date = datePicker.dateValue
        print("Title:", titleTextBox.stringValue)
        if let textView = descriptionTextView.documentView as? NSTextView {
            print("Description:", textView.string)
            description = textView.string
        }
        print("Date:", datePicker.dateValue)
        
        
        clearEntries()
        if let currentReminder = currentReminder {
            success?(currentReminder)
        }
    }
    
    private func fadeOutAnimate(_ view: NSView?) {
        view?.layer?.opacity = 0
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 2
        view?.layer?.add(animation, forKey: nil)
    }
    
    private func addAllSubViews() {
        subviews = [profilePhotoView, titleTextBox, datePickerButton, descriptionTextView, repeatPatternView, responseLabel, saveButton, cancelButton]
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
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextBox.bottomAnchor, constant: 5),
            descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            descriptionTextView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            repeatPatternView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 5),
            repeatPatternView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            
            responseLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -5),
            responseLabel.centerXAnchor.constraint(equalTo: saveButton.leftAnchor),
            
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            
            cancelButton.rightAnchor.constraint(equalTo: saveButton.leftAnchor, constant: -10),
            cancelButton.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 5),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
        ])
    }
    
    override func viewDidMoveToWindow() {
        resetFirstResponder()
    }
}
