//
//  Formatting.swift
//  RPN-30
//
//  Created by Ashok Khanna on 1/2/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

extension Calculator {
    
    func formatCalculator(){
        
        setLabelFonts()
        setColors()
        makeButtonsRound()

    }
    
    func setLabelFonts(){
        
        // Set font sizes, colors and alignments for output display
        sRegisterDisplay.textAlignment = .center
        yRegisterDisplay.textAlignment = .left
        lRegisterDisplay.textAlignment = .left
        mainDisplay.textAlignment = .center
        
        sRegisterDisplay.textColor = .white
        yRegisterDisplay.textColor = .white
        lRegisterDisplay.textColor = .darkGray
        mainDisplay.textColor = .white
        
        sRegisterDisplay.font = UIFont.systemFont(ofSize: 9.0)
        sRegisterDisplay.numberOfLines = 0
        

        yRegisterDisplay.font = UIFont.systemFont(ofSize: 30.0)
        lRegisterDisplay.font = UIFont.systemFont(ofSize: 14.0)
        mainDisplay.font = UIFont.systemFont(ofSize: 40.0)
        
        sRegisterDisplay.adjustsFontSizeToFitWidth = true
        yRegisterDisplay.adjustsFontSizeToFitWidth = true
        lRegisterDisplay.adjustsFontSizeToFitWidth = true
        mainDisplay.adjustsFontSizeToFitWidth = true
        
    }
    
    func setColors(){
        
        let translucentOrange = UIColor.init(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5)
        let translucentLightOrange = UIColor.init(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 0.75)
        let translucentDarkGray = UIColor.init(white: 1.0 / 3.0, alpha: 0.5)
        let translucentLightGray = UIColor.init(white: 2.0 / 3.0, alpha: 0.5)
        var translucentLighterOrange = translucentLightOrange.lighter(by: 50.0)
        
        decimalButton.backgroundColor = translucentDarkGray
        zeroButton.backgroundColor = translucentDarkGray
        oneButton.backgroundColor = translucentDarkGray
        twoButton.backgroundColor = translucentDarkGray
        threeButton.backgroundColor = translucentDarkGray
        fourButton.backgroundColor = translucentDarkGray
        fiveButton.backgroundColor = translucentDarkGray
        sixButton.backgroundColor = translucentDarkGray
        sevenButton.backgroundColor = translucentDarkGray
        eightButton.backgroundColor = translucentDarkGray
        nineButton.backgroundColor = translucentDarkGray
    
        
        sRegisterDisplay.backgroundColor = UIColor.init(white: 1.0 / 3.0, alpha: 0.25)
        clearButton.backgroundColor = translucentLightGray
        chsButton.backgroundColor = translucentLightGray
        divideButton.backgroundColor = translucentLightGray
        multiplyButton.backgroundColor = translucentOrange
        minusButton.backgroundColor = translucentOrange
        plusButton.backgroundColor = translucentOrange
        enterButton.backgroundColor = translucentOrange
        
        oneButton.highlightColor = .lightGray
        twoButton.highlightColor = .lightGray
        threeButton.highlightColor = .lightGray
        fourButton.highlightColor = .lightGray
        fiveButton.highlightColor = .lightGray
        sixButton.highlightColor = .lightGray
        sevenButton.highlightColor = .lightGray
        eightButton.highlightColor = .lightGray
        nineButton.highlightColor = .lightGray
        
        
    }

    
    func makeButtonsRound(){
        
        for case let button as CalculatorButton in self.subviews  {
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
        
        sRegisterDisplay.layer.cornerRadius = 8.75
        sRegisterDisplay.clipsToBounds = true
        
    }
    
    
    func setupNSFormatters(){
        
        formatterScientific.numberStyle = .scientific
        formatterScientific.maximumSignificantDigits = 6
        formatterScientific.usesSignificantDigits = true
        
        
        formatterDecimal.numberStyle = .decimal
        formatterDecimal.maximumFractionDigits = 5
        
    }
    
}
