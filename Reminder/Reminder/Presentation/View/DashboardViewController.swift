//
//  DashboardViewController.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class DashboardViewController: NSViewController, DashboardViewControllerContract {
    
    private var createReminderView: CreateReminderView = CreateReminderView()
    private var reminderListView: ReminderListView = ReminderListView()
    private var editReminderView: EditReminderView = EditReminderView()
    var dashboardPresenter: DashboardPresenterContract
    
    override func viewDidLoad() {
        print("Dashboard view loaded")
    }
    
    init(dashboardPresenter: DashboardPresenterContract) {
        self.dashboardPresenter = dashboardPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("dashboard vc deinit")
    }
    
    override func loadView() {
        configureSplitView()
        view.wantsLayer = true
        view.layer?.contents = NSImage(named: "background")
        view.layer?.contentsGravity = .resizeAspectFill
    }
    
    private func configureSplitView() {
        let splitView = NSSplitView()
        view = splitView
        splitView.setFrameSize(NSSize(width: 1000, height: 600))
        splitView.isVertical = true
        
        splitView.addArrangedSubview(reminderListView)
//        splitView.addArrangedSubview(NSView())
        reminderListView.load(self)
        splitView.addArrangedSubview(createReminderView)
        createReminderView.load(self)
    }
    
    func getLastLoggedInUserImageURL(success: @escaping (URL?) -> Void, failure: @escaping (String) -> Void) {
        dashboardPresenter.getLastLoggedInUserImageURL(success: success, failure: failure)
    }
    
    func changeViewToLogin() {
        dashboardPresenter.changeViewControllerToLogin()
    }
    
    func addReminder(title: String, description: String, date: Date, repeatPattern: RepeatPattern, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        // refresh data source of table view
        dashboardPresenter.addReminder(title: title, description: description, date: date, repeatPattern: repeatPattern, success: success, failure: failure)
        reminderListView.addReminder(reminder: Reminder(addedTime: Date.now, title: title, description: description, eventTime: date, repeatTiming: repeatPattern))
    }
    
    func changeViewToEditReminder(reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (String) -> Void) {
        // get 2 parameters(reminder, callback)
        // get a callback which should execute the reloadData of index of the reminder which is sent here
        // update the editReminderView with reminder values got through parameter
        // after setting, execute reminder callback there when save is clicked
//        editReminderView.load(self, reminder: reminder, success: success, failure: failure)
        // add definition in EditReminderView and set callback in save button action
        // change callback to reset to create reminder view 
//        (view as? NSSplitView)?.arrangedSubviews[1].removeFromSuperview()
//        (view as? NSSplitView)?.addArrangedSubview(editReminderView)
    }
}
