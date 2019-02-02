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
        
        sRegisterDisplay.textAlignment = .center
        yRegisterDisplay.textAlignment = .left
        lRegisterDisplay.textAlignment = .left
        xRegisterDisplay.textAlignment = .center
        
        sRegisterDisplay.textColor = .white
        yRegisterDisplay.textColor = .white
        lRegisterDisplay.textColor = .darkGray
        xRegisterDisplay.textColor = .white
        
        sRegisterDisplay.font = UIFont.systemFont(ofSize: 9.0)
        yRegisterDisplay.font = UIFont.systemFont(ofSize: 30.0)
        lRegisterDisplay.font = UIFont.systemFont(ofSize: 14.0)
        xRegisterDisplay.font = UIFont.systemFont(ofSize: 40.0)
        
        sRegisterDisplay.numberOfLines = 0
        
        sRegisterDisplay.adjustsFontSizeToFitWidth = true
        yRegisterDisplay.adjustsFontSizeToFitWidth = true
        lRegisterDisplay.adjustsFontSizeToFitWidth = true
        xRegisterDisplay.adjustsFontSizeToFitWidth = true

    }
    
    func setColors(){
        
        let translucentOrange = UIColor.init(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5)
        let translucentLightOrange = UIColor.init(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 0.75)
        let translucentLightGray = UIColor.init(white: 2.0 / 3.0, alpha: 0.5)
        let translucentLighterOrange = translucentLightOrange.lighter(by: 50.0)
        
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
        
        multiplyButton.highlightColor = translucentLighterOrange
        minusButton.highlightColor = translucentLighterOrange
        plusButton.highlightColor = translucentLighterOrange
        enterButton.highlightColor = translucentLighterOrange
        
        clearButton.highlightColor = .lightGray
        chsButton.highlightColor = .lightGray
        divideButton.highlightColor = .lightGray
        
        zeroButton.highlightColor = .lightGray
        decimalButton.highlightColor = .lightGray
        
        
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
        
        // formatterBasic.numberStyle = .decimal
        formatterBasic.groupingSeparator = ""
        
    }
    
    func changeFunctionLabelToOrange(_ whichDigit: String){
        
        switch whichDigit {
        case "decimal":
            decimalFunctionLabel.backgroundColor = .orange
            decimalFunctionLabel.textColor = .white
        case "zero":
            zeroFunctionLabel.backgroundColor = .orange
            zeroFunctionLabel.textColor = .white
        case "one":
            oneFunctionLabel.backgroundColor = .orange
            oneFunctionLabel.textColor = .white
        case "two":
            twoFunctionLabel.backgroundColor = .orange
            twoFunctionLabel.textColor = .white
        case "three":
            threeFunctionLabel.backgroundColor = .orange
            threeFunctionLabel.textColor = .white
        case "four":
            fourFunctionLabel.backgroundColor = .orange
            fourFunctionLabel.textColor = .white
        case "five":
            fiveFunctionLabel.backgroundColor = .orange
            fiveFunctionLabel.textColor = .white
        case "six":
            sixFunctionLabel.backgroundColor = .orange
            sixFunctionLabel.textColor = .white
        case "seven":
            sevenFunctionLabel.backgroundColor = .orange
            sevenFunctionLabel.textColor = .white
        case "eight":
            eightFunctionLabel.backgroundColor = .orange
            eightFunctionLabel.textColor = .white
        case "nine":
            nineFunctionLabel.backgroundColor = .orange
            nineFunctionLabel.textColor = .white
        default:
            break
        }
        
    }
    
    func changeFunctionLabelToLightGray(_ whichDigit: String){
        
        switch whichDigit {
        case "decimal":
            decimalFunctionLabel.backgroundColor = .lightGray
            decimalFunctionLabel.textColor = .darkGray
        case "zero":
            zeroFunctionLabel.backgroundColor = .lightGray
            zeroFunctionLabel.textColor = .darkGray
        case "one":
            oneFunctionLabel.backgroundColor = .lightGray
            oneFunctionLabel.textColor = .darkGray
        case "two":
            twoFunctionLabel.backgroundColor = .lightGray
            twoFunctionLabel.textColor = .darkGray
        case "three":
            threeFunctionLabel.backgroundColor = .lightGray
            threeFunctionLabel.textColor = .darkGray
        case "four":
            fourFunctionLabel.backgroundColor = .lightGray
            fourFunctionLabel.textColor = .darkGray
        case "five":
            fiveFunctionLabel.backgroundColor = .lightGray
            fiveFunctionLabel.textColor = .darkGray
        case "six":
            sixFunctionLabel.backgroundColor = .lightGray
            sixFunctionLabel.textColor = .darkGray
        case "seven":
            sevenFunctionLabel.backgroundColor = .lightGray
            sevenFunctionLabel.textColor = .darkGray
        case "eight":
            eightFunctionLabel.backgroundColor = .lightGray
            eightFunctionLabel.textColor = .darkGray
        case "nine":
            nineFunctionLabel.backgroundColor = .lightGray
            nineFunctionLabel.textColor = .darkGray
        default:
            break
        }
        
    }
    
    func changeFunctionLabelToDarkGray(_ whichDigit: String){
        
        switch whichDigit {
        case "decimal":
            decimalFunctionLabel.backgroundColor = .darkGray
            decimalFunctionLabel.textColor = .lightGray
        case "zero":
            zeroFunctionLabel.backgroundColor = .darkGray
            zeroFunctionLabel.textColor = .lightGray
        case "one":
            oneFunctionLabel.backgroundColor = .darkGray
            oneFunctionLabel.textColor = .lightGray
        case "two":
            twoFunctionLabel.backgroundColor = .darkGray
            twoFunctionLabel.textColor = .lightGray
        case "three":
            threeFunctionLabel.backgroundColor = .darkGray
            threeFunctionLabel.textColor = .lightGray
        case "four":
            fourFunctionLabel.backgroundColor = .darkGray
            fourFunctionLabel.textColor = .lightGray
        case "five":
            fiveFunctionLabel.backgroundColor = .darkGray
            fiveFunctionLabel.textColor = .lightGray
        case "six":
            sixFunctionLabel.backgroundColor = .darkGray
            sixFunctionLabel.textColor = .lightGray
        case "seven":
            sevenFunctionLabel.backgroundColor = .darkGray
            sevenFunctionLabel.textColor = .lightGray
        case "eight":
            eightFunctionLabel.backgroundColor = .darkGray
            eightFunctionLabel.textColor = .lightGray
        case "nine":
            nineFunctionLabel.backgroundColor = .darkGray
            nineFunctionLabel.textColor = .lightGray
        default:
            break
        }
        
    }
    
}
