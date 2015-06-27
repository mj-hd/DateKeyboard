//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by OtsukaYusuke on 2015/01/02.
//  Copyright (c) 2015年 OtsukaYusuke. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet weak var nextKeyboardButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var formatSelector: UISegmentedControl!
    @IBOutlet weak var datePicker: CustomizableDatePicker!
    @IBOutlet weak var PreviewLabel: UILabel!
    @IBOutlet weak var weekdayButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var centralView: UIView!
    
    var numericalView: UIView!
    var warningLabel: UILabel!
    
    var inputNumber = 0
    var isEnabledWeekday = false
    var lightGrayColor: UIColor?
    
    var defaults :NSUserDefaults?

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Mint.sharedInstance().initAndStartSession("51631c98")
        
    
        // Perform custom UI setup here
        var view = UINib(nibName: "KeyboardView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as UIView
        
        view.frame = self.view.frame
        
        
        // configuring of numericalView
        numericalView = UINib(nibName: "NumericalView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as UIView
        numericalView.hidden = true
        
        self.inputView.addSubview(view)
        self.centralView.addSubview(numericalView)
        
        self.centralView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.numericalView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
 
        var constraints = [
            NSLayoutConstraint(
                item: numericalView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: datePicker,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: numericalView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: datePicker,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: numericalView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: datePicker,
                attribute: .Width,
                multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(
                item: numericalView,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: datePicker,
                attribute: .Height,
                multiplier: 1.0,
                constant: 0.0)
        ]
        
        self.centralView.addConstraints(constraints)
        
        // load user defaults
        if (!self.isOpenAccessGranted) {
           
            // if can't load user defaults, hide datepicker
            self.datePicker.hidden = true
            //self.formatSelector.enabled = false
            
            var warningLabel = UILabel()
            warningLabel.text = "フルアクセスが許可されていないため、現在の日付の入力と数字キーボードのみ使用することができます。"
            warningLabel.numberOfLines = 0
            warningLabel.lineBreakMode = .ByWordWrapping
            warningLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.warningLabel = warningLabel
            
            self.centralView.addSubview(warningLabel)
            
            var constraints = [
                NSLayoutConstraint(
                    item: warningLabel,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self.centralView,
                    attribute: .Top,
                    multiplier: 1.0,
                    constant: 5.0
                ),
                NSLayoutConstraint(
                    item: warningLabel,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: self.centralView,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: 5.0
                ),
                NSLayoutConstraint(
                    item: warningLabel,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: self.centralView,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: 5.0
                ),
                NSLayoutConstraint(
                    item: warningLabel,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self.centralView,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: 5.0
                )
            ]
            
            self.centralView.addConstraints(constraints)
            
            NSLog("Warning: DateKeyboard is not allowed to access shared containers.")
            
        } else {
            self.defaults = NSUserDefaults(suiteName: Defaults.SuiteName)
            self.defaults?.registerDefaults(Defaults.Values)
        }
        
        datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
        
        self.PreviewLabel.text = self.generateDateString()
        
        self.lightGrayColor = self.nextKeyboardButton.backgroundColor
        
        if let format = self.defaults?.integerForKey("lastSelectedFormat") {
            self.formatSelector.selectedSegmentIndex = min(max(format, 0), 3)
            self.formatChanged(formatSelector)
        }
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    private func generateDateString() -> String {
        
        var d : [NSObject : AnyObject] = Defaults.Values
        var suffix = ""
        
        if (self.defaults != nil) {
            d = self.defaults!.dictionaryRepresentation()
        }
        
        var formatter = NSDateFormatter()
        
        if (d["useEnglishFormat"] as Bool) {
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            suffix = "E"
        }
        
        switch self.datePicker.datePickerMode {
        case .YearMonthDay:
            
            if (self.isEnabledWeekday) {
                formatter.dateFormat = (d["yearMonthDayWeekdayFormat" + suffix] as String)
            } else {
                formatter.dateFormat = (d["yearMonthDayFormat" + suffix] as String)
            }
            
        case .MonthDay:
            
            if (self.isEnabledWeekday) {
                formatter.dateFormat = (d["monthDayWeekdayFormat" + suffix] as String)
            } else {
                formatter.dateFormat = (d["monthDayFormat" + suffix] as String)
            }
            
        case .Time:
            
            formatter.dateFormat = (d["timeFormat" + suffix] as String)
            
        }
        
        return formatter.stringFromDate(self.datePicker.date)
    }
    
    private var _isOpenAccessGranted :Bool?
    private var isOpenAccessGranted :Bool {
        get {
            if (self._isOpenAccessGranted != nil) {
                return self._isOpenAccessGranted!
            }
        
            let fm = NSFileManager.defaultManager()
            let containerPath = fm.containerURLForSecurityApplicationGroupIdentifier(Defaults.SuiteName)?.path
            var error: NSError?
        
            fm.contentsOfDirectoryAtPath(containerPath!, error: &error)
        
            self._isOpenAccessGranted = (error == nil)
        
            return self._isOpenAccessGranted!
        }
    }
    
    @IBAction func nextKeyboardButtonTapped(sender: AnyObject) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func enterButtonTapped(sender: AnyObject) {
        
        var proxy = textDocumentProxy as UITextDocumentProxy
        var text = self.generateDateString()

        proxy.insertText(text)
        
        self.inputNumber = text.utf16Count
        
        self.cancelButton.setImage(UIImage(named: "kana_multitap_reverse_arrow"), forState: .Normal)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        if self.inputNumber > 0 {
            
            while self.inputNumber-- > 0 {
                proxy.deleteBackward()
            }
            
        } else {
            proxy.deleteBackward()
        }
        
        self.cancelButton.setImage(UIImage(named: "delete_portrait"), forState: .Normal)
    }
    
    @IBAction func formatChanged(sender: AnyObject) {
        if (!self.isOpenAccessGranted) {
            
            if (formatSelector.selectedSegmentIndex == 3) {
                
                self.warningLabel.hidden = true
                
                self.PreviewLabel.enabled = false
                self.datePicker.hidden = true
                self.enterButton.enabled = false
                self.weekdayButton.enabled = false
                self.numericalView.hidden = false
                
            } else {
                
                self.warningLabel.hidden = false
                
                self.PreviewLabel.enabled = true
                self.datePicker.hidden = true
                self.enterButton.enabled = true
                self.weekdayButton.enabled = true
                self.numericalView.hidden = true
 
            }
            
            return
        }
        
        
        self.PreviewLabel.enabled = true
        self.datePicker.hidden = false
        self.enterButton.enabled = true
        self.weekdayButton.enabled = true
        self.numericalView.hidden = true
        
        switch formatSelector.selectedSegmentIndex {
        case 0: // 年月日
            self.datePicker.datePickerMode = .YearMonthDay
            
        case 1: // 月日
            self.datePicker.datePickerMode = .MonthDay
            
        case 2: // 時間
            self.datePicker.datePickerMode = .Time
        
        case 3: // 数字
            self.PreviewLabel.text = ""
            self.PreviewLabel.enabled = false
            self.datePicker.hidden = true
            self.enterButton.enabled = false
            self.weekdayButton.enabled = false
            self.numericalView.hidden = false
            
        default:
            break
        }
        
        self.PreviewLabel.text = self.generateDateString()
        
        self.defaults?.setValue(formatSelector.selectedSegmentIndex, forKey: "lastSelectedFormat")
        self.defaults?.synchronize()
    }
    
    @IBAction func weekdayButtonTapped(sender: AnyObject) {
        self.isEnabledWeekday = !self.isEnabledWeekday
        (sender as UIButton).selected = !(sender as UIButton).selected
        
        self.PreviewLabel.text = self.generateDateString()
    }
    
    func datePickerValueChanged(sender: AnyObject) {
        self.PreviewLabel.text = self.generateDateString()
    }
    
    // change color of buttons
    @IBAction func nextButtonTouchDown(sender: AnyObject) {
        self.nextKeyboardButton.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func nextButtonTouchUpInside(sender: AnyObject) {
        self.nextKeyboardButton.backgroundColor = self.lightGrayColor
    }
    
    @IBAction func cancelButtonTouchDown(sender: AnyObject) {
        self.cancelButton.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func cancelButtonTouchUpInside(sender: AnyObject) {
        self.cancelButton.backgroundColor = self.lightGrayColor
    }
    
    @IBAction func enterButtonTouchDown(sender: AnyObject) {
        self.enterButton.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func enterButtonTouchUpInside(sender: AnyObject) {
        self.enterButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func weekdayButtonTouchDown(sender: AnyObject) {
    }
    @IBAction func weekdayButtonTouchUpInside(sender: AnyObject) {
    }
    
    // Numerical View
    
    @IBAction func tappedDot(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(".")
    }
    
    @IBAction func tappedMinus(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("/")
    }
    
    @IBAction func tapped0(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("0")
    }
    
    @IBAction func tapped1(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("1")
    }
    
    @IBAction func tapped2(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("2")
    }
    
    @IBAction func tapped3(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("3")
    }
    
    @IBAction func tapped4(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("4")
    }
    
    @IBAction func tapped5(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("5")
    }
    
    @IBAction func tapped6(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("6")
    }
    
    @IBAction func tapped7(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("7")
    }
    
    @IBAction func tapped8(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("8")
    }
    
    @IBAction func tapped9(sender: AnyObject) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText("9")
    }
    
    @IBAction func tapped(sender: AnyObject) {
        (sender as UIButton).backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func released(sender: AnyObject) {
        (sender as UIButton).backgroundColor = UIColor.whiteColor()
    }
    
}
