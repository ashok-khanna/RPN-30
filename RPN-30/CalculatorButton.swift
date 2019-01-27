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
    
    var stateZero: String?
    var stateOne: String?
    var stateTwo: String?

    var states: [String]?
    
    var originalBackgroundColor: UIColor!
    
    let highlightColor = UIColor(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
    
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
            backgroundColor = isHighlighted ? .white : originalBackgroundColor
        }
    }

}
