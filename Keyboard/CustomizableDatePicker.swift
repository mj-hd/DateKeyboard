//
//  CustomizableDatePicker.swift
//  DateKeyboard
//
//  Created by mjhd on 2015/01/06.
//  Copyright (c) 2015年 OtsukaYusuke. All rights reserved.
//

import Foundation
import UIKit

public class CustomizableDatePicker : UIPickerView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    public required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
   }
    
    var model = CustomizableDatePickerModel()
    
    func setup() {
        self.delegate = self.model
        self.dataSource = self.model
        
        self.model.date = NSDate()
    }
    
    
    public var date : NSDate {
        get {
            return model.date
        }
        set {
            model.date = newValue
            self.reloadAllComponents()
        }
    }
    
    public var components : NSDateComponents {
        get {
            return model.components
        }
        set {
            model.components = newValue
            self.reloadAllComponents()
        }
    }
    
    public var datePickerMode : CustomizableDatePickerMode {
        get {
            return model.datePickerMode
        }
        set {
            model.datePickerMode = newValue
            self.reloadAllComponents()
        }
    }
    
    public override func reloadAllComponents() {
        if (!self.hidden) {
            super.reloadAllComponents()
            self.model.selectCurrentDateComponentsFor(self, animated: true)
            self._reloadComponentLabels();
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if (!self.hidden) {
            self._reloadComponentLabels()
        }
    }
    
    private var _yearLabel :PaddingLabel!
    private var _monthLabel :PaddingLabel!
    private var _dayLabel :PaddingLabel!
    private var _hourLabel :PaddingLabel!
    private var _minuteLabel: PaddingLabel!
    
    private func _reloadComponentLabels() {
        
        if _yearLabel == nil {
            _yearLabel = PaddingLabel()
            _yearLabel.text = "年"
            _yearLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
            _yearLabel.backgroundColor = UIColor.clearColor()
            _yearLabel.insets = UIEdgeInsets(top: 7, left: 5, bottom: 3, right: 5)
            
            self.addSubview(_yearLabel)
        }
        if _monthLabel == nil {
            _monthLabel = PaddingLabel()
            _monthLabel.text = "月"
            _monthLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
            _monthLabel.backgroundColor = UIColor.clearColor()
            _monthLabel.insets = UIEdgeInsets(top: 7, left: 5, bottom: 3, right: 5)
            
            self.addSubview(_monthLabel)
        }
        if _dayLabel == nil {
            _dayLabel = PaddingLabel()
            _dayLabel.text = "日"
            _dayLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
            _dayLabel.backgroundColor = UIColor.clearColor()
            _dayLabel.insets = UIEdgeInsets(top: 7, left: 5, bottom: 3, right: 5)
            
            self.addSubview(_dayLabel)
        }
        if _hourLabel == nil {
            _hourLabel = PaddingLabel()
            _hourLabel.text = "時"
            _hourLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
            _hourLabel.backgroundColor = UIColor.clearColor()
            _hourLabel.insets = UIEdgeInsets(top: 7, left: 5, bottom: 3, right: 5)
            
            self.addSubview(_hourLabel)
        }
        if _minuteLabel == nil {
            _minuteLabel = PaddingLabel()
            _minuteLabel.text = "分"
            _minuteLabel.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
            _minuteLabel.backgroundColor = UIColor.clearColor()
            _minuteLabel.insets = UIEdgeInsets(top: 7, left: 5, bottom: 3, right: 5)
            
            self.addSubview(_minuteLabel)
        }
        
        _yearLabel.hidden = true
        _monthLabel.hidden = true
        _dayLabel.hidden = true
        _hourLabel.hidden = true
        _minuteLabel.hidden = true
        
        let top = self.bounds.origin.y + self.bounds.height / 2 - UIFont.systemFontSize()
        let fontW = UIFont.systemFontSize() * 2
        var height = self.rowSizeForComponent(0).height + 3
        var offset = self.rowSizeForComponent(0).width + 5
        
        switch self.model.datePickerMode {
            
        case .YearMonthDay:
            _yearLabel.hidden = false
            _monthLabel.hidden = false
            _dayLabel.hidden = false
            
            _yearLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
            
            offset += self.rowSizeForComponent(1).width
            
            _monthLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
            
            offset += self.rowSizeForComponent(2).width
            
            _dayLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
            
        case .MonthDay:
            _monthLabel.hidden = false
            _dayLabel.hidden = false
            
            _monthLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
            
            offset += self.rowSizeForComponent(1).width
            
            _dayLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
 
            
        case .Time:
            _hourLabel.hidden = false
            _minuteLabel.hidden = false
            
            _hourLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
            
            offset += self.rowSizeForComponent(1).width
            
            _minuteLabel.frame = CGRect(x: offset - fontW, y: top, width: fontW, height: height)
        }
    }
    
    // UIControl的な
    
    private var valueChangedAction : Selector?
    private var valueChangedTarget : AnyObject?
    
    public func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        if (controlEvents == .ValueChanged) {
            self.valueChangedAction = action
            self.valueChangedTarget = target
        }
    }
    
    public func sendActionsForControlEvents(controlEvents: UIControlEvents) {
        if (controlEvents == .ValueChanged) {
            if (self.valueChangedTarget == nil) {
                return
            }
            if (self.valueChangedAction == nil) {
                return
            }
            
            var myTimer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self.valueChangedTarget!, selector: self.valueChangedAction!, userInfo: nil, repeats: false)
            myTimer.fire()
        }
    }

    
}

public class CustomizableDatePickerModel : NSObject, UIPickerViewDataSource, UIPickerViewDelegate
{
    let rowsMax = 16384
    let yearMin = 1970
    let yearMax = 2100
    let virtYearRows = 2100 - 1970
    let virtMonthRows = 12
    let virtHourRows = 24
    let virtMinuteRows = 60
 
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        var ret : Int
        
        switch self.datePickerMode {
        case .YearMonthDay:
            ret = 3
        case .MonthDay:
            ret = 2
        case .Time:
            ret = 2
        default:
            ret = 0
        }
        
        return ret
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowsMax
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var ret : String
        
        switch self.datePickerMode {
        case .YearMonthDay:
            switch component {
            case 0: // Year
                ret = self._getYearFrom(row).description
            case 1: // Month
                ret = (self._getMonthRowFrom(row) + 1).description
            case 2: // Day
                ret = (self._getDayRowFrom(row) + 1).description
            default:
                ret = "Error"
            }
        case .MonthDay:
            switch component {
            case 0: // Month
                ret = (self._getMonthRowFrom(row) + 1).description
            case 1: // Day
                ret = (self._getDayRowFrom(row) + 1).description
            default:
                ret = "Error"
            }
        case .Time:
            switch component {
            case 0: // Hour
                ret = self._getHourRowFrom(row).description
            case 1: // Minute
                ret = self._getMinuteRowFrom(row).description
            default:
                ret = "Error"
            }
        default:
            ret = "Error"
        }
        
        return ret
    }
    
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.datePickerMode {
        case .YearMonthDay:
            switch component {
            case 0: // Year
                _components.year = self._getYearFrom(row)
            case 1: // Month
                _components.month = self._getMonthRowFrom(row) + 1
                
                var daysMonthHas = self._getDaysMonthHas(_components.year, month: _components.month)
                if (_components.day > daysMonthHas) {
                    _components.day = daysMonthHas
                }
                
                self.selectCurrentDateComponentsFor(pickerView, animated: false)
            case 2: // Day
                _components.day = self._getDayRowFrom(row) + 1
            default:
                break
            }
        case .MonthDay:
            switch component {
            case 0: // Month
                _components.month = self._getMonthRowFrom(row) + 1
                
                var daysMonthHas = self._getDaysMonthHas(_components.year, month: _components.month)
                if (_components.day > daysMonthHas) {
                    _components.day = daysMonthHas
                }
 
                self.selectCurrentDateComponentsFor(pickerView, animated: false)
            case 1: // Day
                _components.day = self._getDayRowFrom(row) + 1
            default:
                break
            }
        case .Time:
            switch component {
            case 0: // Hour
                _components.hour = self._getHourRowFrom(row)
            case 1: // Minute
                _components.minute = self._getMinuteRowFrom(row)
            default:
                break
            }
        default:
            break
        }
        
        (pickerView as CustomizableDatePicker).sendActionsForControlEvents(.ValueChanged)
    }
    
    public func selectCurrentDateComponentsFor(pickerView : UIPickerView, animated isAnimated : Bool) {
        
        let yearBase = (rowsMax/2) - (rowsMax/2) % virtYearRows
        let monthBase = (rowsMax/2) - (rowsMax/2) % virtMonthRows
        var dayBase = (rowsMax/2) - (rowsMax/2) % min(max(_getDaysMonthHas(self.components.year, month: self.components.month), 0), 31)
        let hourBase = (rowsMax/2) - (rowsMax/2) % virtHourRows
        let minuteBase = (rowsMax/2) - (rowsMax/2) % virtMinuteRows
        
        
        switch datePickerMode {
        case .YearMonthDay:
            pickerView.selectRow(self.components.year - yearMin + yearBase, inComponent: 0, animated: isAnimated) // Year
            pickerView.selectRow(self.components.month - 1 + monthBase, inComponent: 1, animated: isAnimated) // Month
            pickerView.selectRow(self.components.day - 1 + dayBase, inComponent: 2, animated: isAnimated) // Day
        case .MonthDay:
            pickerView.selectRow(self.components.month - 1 + monthBase, inComponent: 0, animated: isAnimated) // Month
            pickerView.selectRow(self.components.day - 1 + dayBase, inComponent: 1, animated: isAnimated) // Day
        case .Time:
            pickerView.selectRow(self.components.hour + hourBase, inComponent: 0, animated: isAnimated) // Hour
            pickerView.selectRow(self.components.minute + minuteBase, inComponent: 1, animated: isAnimated) // Minute
        default:
            break
        }
    }
    
    private var _calendar = NSCalendar.currentCalendar()
    private var _components = NSDateComponents()
    public var date : NSDate {
        get {
            
            return _calendar.dateFromComponents(_components)!
        }
        set {
            let flags = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond
            
            _components = _calendar.components(flags, fromDate: newValue)
        }
    }
    
    public var components : NSDateComponents {
        get {
            return _components
        }
        set {
            _components = newValue
        }
    }
    
    private var _datePickerMode  = CustomizableDatePickerMode.YearMonthDay
    public var datePickerMode : CustomizableDatePickerMode {
        get {
            return _datePickerMode
        }
        set {
            _datePickerMode = newValue
        }
    }
    
    private func _getYearFrom(row :Int) -> Int {
       return row % virtYearRows + yearMin
    }
    private func _getYearRowFrom(row :Int) -> Int {
        return row % virtYearRows
    }
    private func _getMonthRowFrom(row :Int) -> Int {
        return row % virtMonthRows
    }
    private func _getDayRowFrom(row :Int) -> Int {
        return _getDayRowFrom(row, virtDayRows: _getDaysMonthHas(_components.year, month: _components.month))
    }
    private func _getDayRowFrom(row :Int, virtDayRows :Int) -> Int {
        return row % virtDayRows
    }
    private func _getHourRowFrom(row :Int) -> Int {
        return row % virtHourRows
    }
    private func _getMinuteRowFrom(row :Int) -> Int {
        return row % virtMinuteRows
    }
    
    private func _getDaysMonthHas(year :Int, month :Int) -> Int {
        if (month < 1) || (month > 12) || (year < yearMin) || (year > yearMax) {
            return 30
        }
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        
        if var date = _calendar.dateFromComponents(components) {
            return _calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length
        } else {
            return 30
        }
    }
}

public enum CustomizableDatePickerMode
{
    case YearMonthDay
    case MonthDay
    case Time
}