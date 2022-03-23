//
//  ReminderListView.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit

class ReminderListView: NSView {
    private var month: NSTextField?
    private var year: NSTextField?
    private var eventsTableView: NSTableView?
    private var parentViewController: NSViewController?
    
    deinit {
        print("calednar view deinit")
    }
    
    func load(_ parentViewController: NSViewController) {
        self.parentViewController = parentViewController
        
    }
}
