//
//  ReminderListView.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit
import ReminderBackEnd

class ReminderListView: NSScrollView {
    private var parentViewController: DashboardViewControllerContract?
    private var reminderTableView: ReminderTableView?
    
    func load(_ parentViewController: NSViewController) {
        // get data from database and on success call updatedata
        guard let parentViewController = parentViewController as? DashboardViewController else { return }
        
        self.parentViewController = parentViewController
        var reminders: [Reminder] = []
        
        //filling sample values
        for index in 1...100 {
            reminders.append(Reminder(addedTime: Date.now, title: "reminder \(index)", description: "Description of reminder \(index)", eventTime: Date.now.addingTimeInterval(TimeInterval(1000000 * index))))
        }
        reminderTableView = ReminderTableView(reminders: reminders, self)
        self.drawsBackground = false
        guard let reminderTableView = reminderTableView else {
            print("reminderDayView returned nil")
            return
        }
        self.documentView = reminderTableView
        self.hasVerticalScroller = true
        self.verticalScrollElasticity = .none
        
        // set min width as table view's width(not constant)
        widthAnchor.constraint(greaterThanOrEqualToConstant: 350).isActive = true
    }
    
    func changeViewToEditReminder() {
//        parentViewController?.changeViewToEditReminder()
    }
    
    func addReminder(reminder: Reminder) {
        reminderTableView?.addReminder(reminder: reminder)
    }
}


extension Date {
    func equalsByDay(date: Date) -> Bool {
        let dateComponents1 = Calendar.current.dateComponents(Set([.day, .month, .year]), from: self)
        let dateComponents2 = Calendar.current.dateComponents(Set([.day, .month, .year]), from: date)
        return dateComponents1.day == dateComponents2.day &&
        dateComponents1.month == dateComponents2.month &&
        dateComponents1.year ==  dateComponents2.year
        
    }
}

class ReminderTableView: NSTableView {
    
    var parentView: ReminderListView?
    
    // reminder instances of a single day
    var reminderTableViewDataSource: [Reminder] = []
    
//    private let dateColumnIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateColumn")
    private let reminderColumnIdentifer = NSUserInterfaceItemIdentifier(rawValue: "reminderColumn")
    
    private let viewColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.25)
    private let selectedViewColor = NSColor.selectedContentBackgroundColor
    
    init(reminders: [Reminder], _ view: NSView) {
        self.parentView = view as? ReminderListView
        self.reminderTableViewDataSource = reminders
        super.init(frame: NSRect())
        load(reminders: reminders)
        backgroundColor = .clear
        selectionHighlightStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(reminders: [Reminder]) {
        
        configureReminderDayView()
        setDataSource(as: reminders)
    }
    
    
    private func setDataSource(as reminders: [Reminder]) {
        guard reminders.count > 0 else { return }
        
        let sortedReminders = reminders.sorted(by: {
            $0.eventTime < $1.eventTime
        })
        
        var groupReminder = sortedReminders[0]
        groupReminder.title = ""
        
        let date = groupReminder.eventTime
        
        var customisedRemindersForGroupRows: [Reminder] = [groupReminder]
        
        for reminder in sortedReminders {
            if reminder.eventTime.equalsByDay(date: date) {
                customisedRemindersForGroupRows.append(reminder)
            } else {
                var tempGroupReminder = reminder
                tempGroupReminder.title = ""
                customisedRemindersForGroupRows.append(tempGroupReminder)
                customisedRemindersForGroupRows.append(reminder)
            }
        }
        
        reminderTableViewDataSource = customisedRemindersForGroupRows
    }
    
    func updateDataSource(with reminders: [Reminder]) {
        print("Reloading data")
        setDataSource(as: reminders)
        reloadData()
    }
    
    private func indexOf(reminder: Reminder, in dataSource: [Reminder]) -> Int {
        if let index = reminderTableViewDataSource.firstIndex(where: {
            reminder.eventTime < $0.eventTime
        }) {
            return index
        } else {
            return reminderTableViewDataSource.count
        }
    }
    
    func addReminder(reminder: Reminder) {
        let index = indexOf(reminder: reminder, in: reminderTableViewDataSource)
        reminderTableViewDataSource.insert(reminder, at: index)
        // check for group row and insert it
        insertGroupRow(for: reminder, beforeIndex: index)
        guard let rangeOfRowsInVisibleRect = Range(rows(in: visibleRect)) else { return }
        print("reloading columns in range \(rangeOfRowsInVisibleRect)")
        reloadData(forRowIndexes: IndexSet(integersIn: rangeOfRowsInVisibleRect), columnIndexes: IndexSet(integer: 0))
//        reloadData()
        // numberOfRows is called as data source size is increased
        noteNumberOfRowsChanged()
    }
    
    private func insertGroupRow(for reminder: Reminder, beforeIndex indexOfReminder: Int) {
        var index = indexOfReminder
        while index >= 0 && reminderTableViewDataSource[index].eventTime.equalsByDay(date: reminder.eventTime) {
            index -= 1
        }
        
        if indexOfReminder == 0 && reminderTableViewDataSource[1].title == "" && (reminderTableViewDataSource[0].eventTime.equalsByDay(date: reminderTableViewDataSource[1].eventTime)){
            let tempReminder = reminderTableViewDataSource[1]
            reminderTableViewDataSource[1] = reminderTableViewDataSource[0]
            reminderTableViewDataSource[0] = tempReminder
            return
        }
        
        if reminderTableViewDataSource[index + 1].title == "" { return }
        
        var groupReminder = reminder
        groupReminder.title = ""
        
        reminderTableViewDataSource.insert(groupReminder, at: index + 1)
    }
    
    private func configureReminderDayView() {
        addColumns()
        self.headerView = nil
        
        dataSource = self
        delegate = self
        
        allowsColumnReordering = false
        allowsColumnResizing = true
        
        intercellSpacing = NSSize(width: 2, height: 2)
        selectionHighlightStyle = .regular
        
        backgroundColor = .textBackgroundColor
    }
    
    private func addColumns() {
        addReminderColumn()
    }
    
    private func addReminderColumn() {
        let reminderColumn = NSTableColumn(identifier: reminderColumnIdentifer)
        reminderColumn.title = "Reminder"
        let reminderColumnMinWidth = CGFloat(300)
        reminderColumn.minWidth = reminderColumnMinWidth
        addTableColumn(reminderColumn)
    }
}

extension ReminderTableView: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let reminderViewIdentifier = NSUserInterfaceItemIdentifier(rawValue: "reminderView")
        let dateViewIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateView")
        if tableColumn?.identifier == nil {
            print("make view called for date: \(reminderTableViewDataSource[row])")
            let dateView = makeView(withIdentifier: dateViewIdentifier, owner: self)
            if let dateView = dateView as? DateView {
                dateView.updateValues(date: reminderTableViewDataSource[row].eventTime)
                return dateView
            } else  {
                let dateView = DateView(date: reminderTableViewDataSource[row].eventTime)
                dateView.identifier = dateViewIdentifier
                return dateView
            }
        } else if tableColumn?.identifier == reminderColumnIdentifer {
            let reminderView = makeView(withIdentifier: reminderViewIdentifier, owner: self)
            if let reminderView = reminderView as? ReminderView {
                reminderView.updateValues(reminder: reminderTableViewDataSource[row])
                
                if row == selectedRow {
                    reminderView.wantsLayer = true
                    reminderView.layer?.backgroundColor = selectedViewColor.cgColor
                } else {
                    reminderView.wantsLayer = true
                    reminderView.layer?.backgroundColor = viewColor.cgColor
                }
                
                return reminderView
            } else  {
                let reminderView = ReminderView()
                reminderView.load(reminder: reminderTableViewDataSource[row])
                reminderView.identifier = reminderViewIdentifier
                return reminderView
            }
        } else {
            return nil
        }
    }
    
    private func updateDateView(_ dateView: DateView, with date: Date) {
        dateView.updateValues(date: date)
    }
    
    private func getDateView(for row: Int) -> DateView? {
        guard reminderTableViewDataSource.count > row else { return nil }
        let date = reminderTableViewDataSource[row].eventTime
        let dateAndDayView = DateView(date: date)
        
        return dateAndDayView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        // same for all rows
        return 70
    }
    
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        // true for first row, as it shows only of 1st column
        if row < reminderTableViewDataSource.count {
            if reminderTableViewDataSource[row].title == "" {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if selectedRow > -1 {
            let view = view(atColumn: selectedColumn, row: selectedRow, makeIfNecessary: false)
            view?.wantsLayer = true
            view?.layer?.backgroundColor = viewColor.cgColor
        }
        if row < reminderTableViewDataSource.count && row > -1 {
            if reminderTableViewDataSource[row].title != "" {
                return true
            }
        }
        return false
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard selectedRow < reminderTableViewDataSource.count && selectedRow > -1 else { return }
        guard reminderTableViewDataSource[selectedRow].title != "" else { return }
        let view = view(atColumn: selectedColumn, row: selectedRow, makeIfNecessary: false)
        view?.wantsLayer = true
        view?.layer?.backgroundColor = selectedViewColor.cgColor
        // call edit reminder of that row
        parentView?.changeViewToEditReminder()
    }
    
    func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        if tableColumn?.identifier == reminderColumnIdentifer {
            return true
        }
        return false
    }
}

extension ReminderTableView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reminderTableViewDataSource.count
    }
}

fileprivate class ReminderView: NSTableCellView {
    private var reminder: Reminder?
    private var titleView = NSTextField()
    private var descriptionView = NSTextField()
    private var timeView = NSTextField()
    private var deleteButton = NSButton()
    
    func load(reminder: Reminder) {
        self.reminder = reminder
        configureReminderView()
        configureTitleView()
        configureDescriptionView()
        configureTimeView()
        configureDeleteButton()
        addSubviews()
        addAllLayoutConstraints()
    }
    
    private func configureReminderView() {
        wantsLayer = true
        layer?.cornerRadius = 5
        layer?.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
    }
    
    private func configureTitleView() {
        guard let reminder = reminder else {
            return
        }
        let titleString = NSAttributedString(string: reminder.title, attributes: [.font: NSFont.preferredFont(forTextStyle: .title3), .foregroundColor: NSColor.labelColor])
        titleView = NSTextField(labelWithAttributedString: titleString)
        titleView.lineBreakMode = .byTruncatingTail
        titleView.maximumNumberOfLines = 1
        let titleViewCell = titleView.cell
        titleViewCell?.truncatesLastVisibleLine = true
    }
    
    private func updateTitle() {
        guard let reminder = reminder else {
            return
        }
        let titleString = NSAttributedString(string: reminder.title, attributes: [.font: NSFont.preferredFont(forTextStyle: .title3), .foregroundColor: NSColor.labelColor])
        titleView.attributedStringValue = titleString
    }
    
    private func configureDescriptionView() {
        guard let reminder = reminder else {
            return
        }
        let descriptionString = NSAttributedString(string: reminder.description, attributes: [.font: NSFont.preferredFont(forTextStyle: .caption1), .foregroundColor: NSColor.secondaryLabelColor])
        descriptionView = NSTextField(labelWithAttributedString: descriptionString)
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.lineBreakStrategy = .standard
        descriptionView.maximumNumberOfLines = 3
        let descriptionViewCell = descriptionView.cell
        descriptionViewCell?.truncatesLastVisibleLine = true
    }
    
    private func updateDescription() {
        guard let reminder = reminder else {
            return
        }
        let descriptionString = NSAttributedString(string: reminder.description, attributes: [.font: NSFont.preferredFont(forTextStyle: .caption1), .foregroundColor: NSColor.secondaryLabelColor])
        descriptionView.attributedStringValue = descriptionString
    }
    
    private func getFormattedTime(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let timeString = dateFormatter.string(from: time)
        return timeString
    }
    
    private func configureTimeView() {
        guard let reminder = reminder else {
            return
        }
        let timeString = getFormattedTime(time: reminder.eventTime)
        let timeViewString = NSAttributedString(string: timeString, attributes: [.font: NSFont.preferredFont(forTextStyle: .headline), .foregroundColor: NSColor.labelColor])
        timeView = NSTextField(labelWithAttributedString: timeViewString)
        timeView.cell?.usesSingleLineMode = true
    }
    
    private func updateTime() {
        guard let reminder = reminder else {
            return
        }
        let timeString = getFormattedTime(time: reminder.eventTime)
        let timeViewString = NSAttributedString(string: timeString, attributes: [.font: NSFont.preferredFont(forTextStyle: .headline), .foregroundColor: NSColor.labelColor])
        timeView.attributedStringValue = timeViewString
    }
    
    private func configureDeleteButton() {
        deleteButton.image = NSImage(named: "delete_icon")
        deleteButton.image?.size = NSSize(width: 30, height: 30)
        deleteButton.isBordered = false
        
        deleteButton.isHidden = true
        
        deleteButton.wantsLayer = true
        deleteButton.layer?.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
        deleteButton.layer?.cornerRadius = 15
        
        deleteButton.target = self
        deleteButton.action = #selector(deleteReminder(_:))
        
    }
    
    @objc func deleteReminder(_ sender: NSButton) {
        guard let rowView = superview as? NSTableRowView else { return }
        guard let reminderDayView = rowView.superview as? ReminderTableView else { return }
        let row = reminderDayView.row(for: rowView)
        if reminderDayView.tableView(reminderDayView, isGroupRow: row - 1) &&
            reminderDayView.tableView(reminderDayView, isGroupRow: row + 1){
            reminderDayView.reminderTableViewDataSource.remove(at: row)
            reminderDayView.removeRows(at: IndexSet(integer: row), withAnimation: .slideLeft)
            reminderDayView.reminderTableViewDataSource.remove(at: row - 1)
            reminderDayView.removeRows(at: IndexSet(integer: row - 1))
        } else {
            reminderDayView.reminderTableViewDataSource.remove(at: row)
            reminderDayView.removeRows(at: IndexSet(integer: row), withAnimation: .slideLeft)
        }
        // delete reminder from dataSource, database and reload selected rows
    }
    
    private func addSubviews() {
        subviews = [titleView, descriptionView, timeView, deleteButton]
    }
    
    private func setTitleViewLayoutConstraints() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            titleView.rightAnchor.constraint(lessThanOrEqualTo: timeView.leftAnchor, constant: -5),
        ])
    }
    
    private func setDescriptionViewLayoutConstraints() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            descriptionView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
            descriptionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            descriptionView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10),
        ])
    }
    
    private func setTimeViewLayoutConstraints() {
        timeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
        ])
    }
    
    private func setDeleteButtonLayoutConstraints() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
        ])
    }
    
    private func addAllLayoutConstraints() {
        setTitleViewLayoutConstraints()
        
        setDescriptionViewLayoutConstraints()
        
        setTimeViewLayoutConstraints()
        
        setDeleteButtonLayoutConstraints()
    }
    
    func updateValues(reminder: Reminder) {
        self.reminder = reminder
        updateTitle()
        updateDescription()
        updateTime()
    }
    
    override func mouseEntered(with event: NSEvent) {
        deleteButton.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        deleteButton.isHidden = true
    }
    
    override func viewDidMoveToWindow() {
        let trackingArea = NSTrackingArea(rect: visibleRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self)
        addTrackingArea(trackingArea)
    }
}

fileprivate class DateView: NSView {
    private var dateView = NSTextField()
    
    private var dayView = NSTextField()
    
    private var monthAndYearView = NSTextField()
    
    init(date: Date) {
        super.init(frame: NSRect())
        load(date: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func load(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM, yyyy"
        let monthAndYearString = dateFormatter.string(from: date)
        
        dateView = NSTextField(labelWithString: dateString)
        dateView.font = NSFont.preferredFont(forTextStyle: .title1)
        dateView.textColor = .labelColor
        
        dayView = NSTextField(labelWithString: dayString)
        dayView.font = NSFont.preferredFont(forTextStyle: .caption1)
        dayView.textColor = .secondaryLabelColor
        
        monthAndYearView = NSTextField(labelWithString: monthAndYearString)
        monthAndYearView.font = NSFont.preferredFont(forTextStyle: .headline)
        monthAndYearView.textColor = .headerTextColor
        monthAndYearView.backgroundColor = .textBackgroundColor
        
        self.addSubview(dateView)
        self.addSubview(dayView)
        self.addSubview(monthAndYearView)
        
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dayView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        monthAndYearView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthAndYearView.topAnchor.constraint(equalTo: self.topAnchor),
            monthAndYearView.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            dateView.topAnchor.constraint(equalTo: monthAndYearView.bottomAnchor, constant: 5),
            dateView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
           
            dayView.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
            dayView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 2),
            
            self.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    func updateValues(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM, yyyy"
        let monthAndYearString = dateFormatter.string(from: date)
        
        dateView.stringValue = dateString
        
        dayView.stringValue = dayString
        
        monthAndYearView.stringValue = monthAndYearString
    }
}
