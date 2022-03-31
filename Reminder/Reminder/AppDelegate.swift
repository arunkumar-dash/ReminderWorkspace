//
//  AppDelegate.swift
//  Reminder
//
//  Created by Arun Kumar on 18/02/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, ReminderRouterContract {

    @IBOutlet var window: NSWindow!
    var appLoginPresenter: AppLoginPresenterContract?
    var dashboardPresenter: DashboardPresenterContract?

    func applicationWillFinishLaunching(_ notification: Notification) {
        print("app will launch")
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("app launched")
        configurePresenters()
    }
    
    func configurePresenters() {
        appLoginPresenter = AppLoginPresenter()
        appLoginPresenter?.router = self
        changeViewControllerToLogin()
        
        dashboardPresenter = DashboardPresenter()
        dashboardPresenter?.router = self
    }
    
    func changeViewControllerToDashboard() {
        let dashboardViewController = DashboardViewController(dashboardPresenter: dashboardPresenter!)
        dashboardPresenter?.dashboardViewController = dashboardViewController
        window.contentViewController = dashboardViewController
        
        let size = NSSize(width: 1000, height: 600)
        window.setContentSize(size)
    }
    
    func changeViewControllerToLogin() {
        let appLoginViewController = AppLoginViewController(appLoginPresenter: appLoginPresenter!)
        appLoginPresenter?.appLoginViewController = appLoginViewController
        window.contentViewController = appLoginViewController
        
        let size = NSSize(width: 600, height: 700)
        window.setContentSize(size)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // save current user details
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

