//
//  CalculatorButton.swift
//  RPN-30
//
//  Created by Ashok Khanna on 23/1/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var digitValue: Double?
    var digitString: String?
    var operationString: String?

    var longPressStartTime = 0.0
    
    var originalBackgroundColor: UIColor!
    
    var highlightColor = UIColor.lightGray
    
    override var backgroundColor: UIColor? {
        didSet {
            if originalBackgroundColor == nil {
                originalBackgroundColor = backgroundColor
            }
        }
    }

    
    override var isHighlighted: Bool {
        didSet {
            guard let originalBackgroundColor = originalBackgroundColor else {
                return
            }
            backgroundColor = isHighlighted ? highlightColor : originalBackgroundColor
        }
    }

}
