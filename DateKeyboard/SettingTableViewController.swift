//
//  SettingTableViewController.swift
//  DateKeyboard
//
//  Created by mjhd on 2015/01/23.
//  Copyright (c) 2015年 OtsukaYusuke. All rights reserved.
//

import Foundation
import UIKit

class SettingTableViewController : UITableViewController, UITableViewDelegate {
    
    @IBOutlet weak var formatCustomizeSwitch: UISwitch!
    @IBOutlet weak var yearMonthDayTextField: UITextField!
    @IBOutlet weak var yearMonthDayWeekdayTextField: UITextField!
    @IBOutlet weak var monthDayTextField: UITextField!
    @IBOutlet weak var monthDayWeekdayTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var englishSwitch: UISwitch!
    
    @IBOutlet weak var yearMonthDayCell: UITableViewCell!
    @IBOutlet weak var yearMonthDayWeekdayCell: UITableViewCell!
    @IBOutlet weak var monthDayCell: UITableViewCell!
    @IBOutlet weak var monthDayWeekdayCell: UITableViewCell!
    @IBOutlet weak var timeCell: UITableViewCell!
    @IBOutlet weak var explanationCell: UITableViewCell!
    
    @IBOutlet weak var explanationTextLabel: UITextView!
    
    var defaults :NSUserDefaults!
    
    override func viewDidLoad() {
        self.defaults = NSUserDefaults(suiteName: Defaults.SuiteName)
        self.defaults.registerDefaults(Defaults.Values)
        
        self.formatCustomizeSwitch.on = self.defaults.boolForKey("useCustomizableFormat")
        self.englishSwitch.on = self.defaults.boolForKey("useEnglishFormat")
        
        self.formatCustomizeSwitch.sendActionsForControlEvents(.ValueChanged)
        self.englishSwitch.sendActionsForControlEvents(.ValueChanged)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath == tableView.indexPathForCell(self.explanationCell)) {
            return self.explanationTextLabel.contentSize.height as CGFloat
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    
    @IBAction func textFieldOnExit(sender: AnyObject) {
        (sender as UITextField).sendActionsForControlEvents(.ValueChanged)
    }
    
    @IBAction func formatSwitched(sender: AnyObject) {
        if (self.formatCustomizeSwitch.on) {
            self.yearMonthDayCell.hidden = false
            self.yearMonthDayWeekdayCell.hidden = false
            self.monthDayCell.hidden = false
            self.monthDayWeekdayCell.hidden  = false
            self.timeCell.hidden = false
            self.explanationCell.hidden = false
        } else {
            self.yearMonthDayCell.hidden = true
            self.yearMonthDayWeekdayCell.hidden = true
            self.monthDayCell.hidden = true
            self.monthDayWeekdayCell.hidden  = true
            self.timeCell.hidden = true
            self.explanationCell.hidden = true
        }
        
        self.defaults.setBool(self.formatCustomizeSwitch.on, forKey: "useCustomizableFormat")
        self.defaults.synchronize()
    }
    @IBAction func englishFormatSwitched(sender: AnyObject) {
        if (self.englishSwitch.on) {
            self.yearMonthDayTextField.text = self.defaults.stringForKey("yearMonthDayFormatE")
            self.yearMonthDayWeekdayTextField.text = self.defaults.stringForKey("yearMonthDayWeekdayFormatE")
            self.monthDayTextField.text = self.defaults.stringForKey("monthDayFormatE")
            self.monthDayWeekdayTextField.text = self.defaults.stringForKey("monthDayWeekdayFormatE")
            self.timeTextField.text = self.defaults.stringForKey("timeFormatE")
            
            self.yearMonthDayTextField.placeholder = (Defaults.Values["yearMonthDayFormatE"] as String)
            self.yearMonthDayWeekdayTextField.placeholder = (Defaults.Values["yearMonthDayWeekdayFormatE"] as String)
            self.monthDayTextField.placeholder = (Defaults.Values["monthDayFormatE"] as String)
            self.monthDayWeekdayTextField.placeholder = (Defaults.Values["monthDayWeekdayFormatE"] as String)
            self.timeTextField.placeholder = (Defaults.Values["timeFormatE"] as String)
        } else {
            self.yearMonthDayTextField.text = self.defaults.stringForKey("yearMonthDayFormat")
            self.yearMonthDayWeekdayTextField.text = self.defaults.stringForKey("yearMonthDayWeekdayFormat")
            self.monthDayTextField.text = self.defaults.stringForKey("monthDayFormat")
            self.monthDayWeekdayTextField.text = self.defaults.stringForKey("monthDayWeekdayFormat")
            self.timeTextField.text = self.defaults.stringForKey("timeFormat")
            
            self.yearMonthDayTextField.placeholder = (Defaults.Values["yearMonthDayFormat"] as String)
            self.yearMonthDayWeekdayTextField.placeholder = (Defaults.Values["yearMonthDayWeekdayFormat"] as String)
            self.monthDayTextField.placeholder = (Defaults.Values["monthDayFormat"] as String)
            self.monthDayWeekdayTextField.placeholder = (Defaults.Values["monthDayWeekdayFormat"] as String)
            self.timeTextField.placeholder = (Defaults.Values["timeFormat"] as String)
        }
        
        self.defaults.setBool(englishSwitch.on, forKey: "useEnglishFormat")
        self.defaults.synchronize()
    }
    
    @IBAction func yearMonthDayChanged(sender: AnyObject) {
        if (self.yearMonthDayTextField.text == "") {
            self.yearMonthDayTextField.text = (Defaults.Values["yearMonthDayFormat"] as String)
        }
        
        self.defaults.setValue(self.yearMonthDayTextField.text, forKey: "yearMonthDayFormat")
        self.defaults.synchronize()
    }
    @IBAction func yearMonthDayWeekdayChanged(sender: AnyObject) {
        if (self.yearMonthDayWeekdayTextField.text == "") {
            self.yearMonthDayWeekdayTextField.text = (Defaults.Values["yearMonthDayWeekdayFormat"] as String)
        }
        
        self.defaults.setValue(self.yearMonthDayWeekdayTextField.text, forKey: "yearMonthDayWeekdayFormat")
        self.defaults.synchronize()
    }
    @IBAction func monthDayChanged(sender: AnyObject) {
        if (self.monthDayTextField.text == "") {
            self.monthDayTextField.text = (Defaults.Values["monthDayFormat"] as String)
        }
        
        self.defaults.setValue(self.monthDayTextField.text, forKey: "monthDayFormat")
        self.defaults.synchronize()
    }
    @IBAction func monthDayWeekdayChanged(sender: AnyObject) {
        if (self.monthDayWeekdayTextField.text == "") {
            self.monthDayWeekdayTextField.text = (Defaults.Values["monthDayWeekdayFormat"] as String)
        }
        
        self.defaults.setValue(self.monthDayWeekdayTextField.text, forKey: "monthDayWeekdayFormat")
        self.defaults.synchronize()
    }
    @IBAction func timeChanged(sender: AnyObject) {
        if (self.timeTextField.text == "") {
            self.timeTextField.text = (Defaults.Values["timeFormat"] as String)
        }
        
        self.defaults.setValue(self.timeTextField.text, forKey: "timeFormat")
        self.defaults.synchronize()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.tableView.endEditing(true)
    }
}