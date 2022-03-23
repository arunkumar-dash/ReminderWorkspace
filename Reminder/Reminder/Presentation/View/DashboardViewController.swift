//
//  DashboardViewController.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit

class DashboardViewController: NSViewController, DashboardViewControllerContract {
    private var createReminderView: CreateReminderView = CreateReminderView()
    private var reminderListView: ReminderListView = ReminderListView()
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
    
    func addReminder(title: String, description: String, date: Date, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        dashboardPresenter.addReminder(title: title, description: description, date: date, success: success, failure: failure)
    }
}
