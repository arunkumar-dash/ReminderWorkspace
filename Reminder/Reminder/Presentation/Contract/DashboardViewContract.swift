//
//  DashboardViewContract.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit

protocol DashboardViewContract: NSView {
    func load(_ viewController: NSViewController)
}
