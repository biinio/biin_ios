//  BNUIBiinItLargeButton.swift
//  biin
//  Created by Esteban Padilla on 2/5/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import Foundation
import UIKit
import CoreGraphics
import QuartzCore

class BNUIBiinItLargeButton:UIButton {
    
    var icon:BNIcon?
    var iconType:BNIconType = BNIconType.leftArrowSmall
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = BNIcon_BiinItLargeButton(color: UIColor.biinColor(), position: CGPointMake(1, 1))
    }
    
    
    override func drawRect(rect: CGRect) {
        if iconType != BNIconType.none {
            icon?.drawCanvas()
        }
    }
}
