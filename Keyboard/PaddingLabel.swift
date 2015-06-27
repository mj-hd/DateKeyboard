//
//  PaddingLabel.swift
//  DateKeyboard
//
//  Created by mjhd on 2015/03/06.
//  Copyright (c) 2015年 OtsukaYusuke. All rights reserved.
//

import Foundation
import UIKit

public class PaddingLabel : UILabel {
    
    public var insets = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
    
    public override func drawTextInRect(rect: CGRect) {
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}