//
//  InitializeButtons.swift
//  RPN-30
//
//  Created by Ashok Khanna on 1/2/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

extension Calculator {
    
    func initButtons(){
        
        addAllToSubview()
        
        xRegisterDisplay.isUserInteractionEnabled = true
        sRegisterDisplay.isUserInteractionEnabled = true
        lRegisterDisplay.isUserInteractionEnabled = true
        yRegisterDisplay.isUserInteractionEnabled = true
        
        let functionTitleColor = UIColor.darkGray
        let functionTextColor = UIColor.lightGray
        let digitTitleSize = UIFont.boldSystemFont(ofSize: 22.5)
        let textTitleSize = UIFont.boldSystemFont(ofSize: 18.0)
        let symbolTitleSize = UIFont.systemFont(ofSize: 30.0)
        
        zeroButton.digitValue = 0.0
        oneButton.digitValue = 1.0
        twoButton.digitValue = 2.0
        threeButton.digitValue = 3.0
        fourButton.digitValue = 4.0
        fiveButton.digitValue = 5.0
        sixButton.digitValue = 6.0
        sevenButton.digitValue = 7.0
        eightButton.digitValue = 8.0
        nineButton.digitValue = 9.0
        
        oneButton.digitString = "one"
        twoButton.digitString = "two"
        threeButton.digitString = "three"
        fourButton.digitString = "four"
        fiveButton.digitString = "five"
        sixButton.digitString = "six"
        sevenButton.digitString = "seven"
        eightButton.digitString = "eight"
        nineButton.digitString = "nine"
        
        oneButton.operationString = "y^x"
        twoButton.operationString = "x√y"
        threeButton.operationString = "1/x"
        fourButton.operationString = "sin x"
        fiveButton.operationString = "asin x"
        sixButton.operationString = "x!"
        sevenButton.operationString = "e^x"
        eightButton.operationString = "ln x"
        nineButton.operationString = "EE"
        
        zeroFunctionLabel.adjustsFontSizeToFitWidth = true
        decimalFunctionLabel.adjustsFontSizeToFitWidth = true
    
        // NSMutableAttributedStrings are used to store strings with formatting
        var myMutableString = NSMutableAttributedString()
        
        // Need to add alignment
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        // Text labels for operations buttons
        
        myMutableString = NSMutableAttributedString(string: "CLR", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: textTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        clearButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "CHS", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: textTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        chsButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "DIV", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: textTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        divideButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "×", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: symbolTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        multiplyButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "−", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: symbolTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        minusButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: symbolTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        plusButton.setAttributedTitle(myMutableString, for: .normal)
        
        myMutableString = NSMutableAttributedString(string: "ENTER", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: textTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        enterButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for decimalButton
        myMutableString = NSMutableAttributedString(string: "·", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28), NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        decimalButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for zeroButton
        myMutableString = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        zeroButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for oneButton
        myMutableString = NSMutableAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        oneButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for twoButton
        myMutableString = NSMutableAttributedString(string: "2", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        twoButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for threeButton
        myMutableString = NSMutableAttributedString(string: "3", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        threeButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for fourButton
        myMutableString = NSMutableAttributedString(string: "4", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        fourButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for fiveButton
        myMutableString = NSMutableAttributedString(string: "5", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        fiveButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for sixButton
        myMutableString = NSMutableAttributedString(string: "6", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        sixButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text table for sevenButton
        myMutableString = NSMutableAttributedString(string: "7", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        sevenButton.setAttributedTitle(myMutableString, for: .normal)
        sevenButton.titleLabel?.numberOfLines = 0
        
        // Text label for eightButton
        myMutableString = NSMutableAttributedString(string: "8", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        eightButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Text label for nineButton
        myMutableString = NSMutableAttributedString(string: "9", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        
        nineButton.setAttributedTitle(myMutableString, for: .normal)
        
        // Code for decimalButton Label

        decimalFunctionLabel.text = "RECALL"
        decimalFunctionLabel.textColor = functionTextColor
        decimalFunctionLabel.backgroundColor = functionTitleColor
        decimalFunctionLabel.font = functionLabelSize
        decimalFunctionLabel.textAlignment = .center
        decimalFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(decimalFunctionLabel)
        decimalFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        decimalFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        decimalFunctionLabel.centerXAnchor.constraint(equalTo: decimalButton.centerXAnchor, constant: 0.0).isActive = true
        decimalFunctionLabel.bottomAnchor.constraint(equalTo: decimalButton.bottomAnchor, constant: -actualButtonHeight! / 6.0).isActive = true
        
        decimalFunctionLabel.layer.cornerRadius = 5
        decimalFunctionLabel.clipsToBounds = true
        
        // Code for zeroButton Label
        
        zeroFunctionLabel.text = "STORE"
        zeroFunctionLabel.textColor = functionTextColor
        zeroFunctionLabel.backgroundColor = functionTitleColor
        zeroFunctionLabel.font = functionLabelSize
        zeroFunctionLabel.textAlignment = .center
        zeroFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(zeroFunctionLabel)
        zeroFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        zeroFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        zeroFunctionLabel.centerXAnchor.constraint(equalTo: zeroButton.centerXAnchor, constant: 0.0).isActive = true
        zeroFunctionLabel.bottomAnchor.constraint(equalTo: zeroButton.bottomAnchor, constant:  -actualButtonHeight! / 6.0).isActive = true
        
        zeroFunctionLabel.layer.cornerRadius = 5
        zeroFunctionLabel.clipsToBounds = true
        
        // Code for oneButton Label
        
        oneFunctionLabel.text = oneButton.operationString
        oneFunctionLabel.textColor = functionTextColor
        oneFunctionLabel.backgroundColor = functionTitleColor
        oneFunctionLabel.font = functionLabelSize
        oneFunctionLabel.textAlignment = .center
        oneFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(oneFunctionLabel)
        oneFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        oneFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        oneFunctionLabel.centerXAnchor.constraint(equalTo: oneButton.centerXAnchor, constant: 0.0).isActive = true
        oneFunctionLabel.bottomAnchor.constraint(equalTo: oneButton.bottomAnchor, constant: -actualButtonHeight! / 15.0).isActive = true
        
        oneFunctionLabel.layer.cornerRadius = 5
        oneFunctionLabel.clipsToBounds = true
        
        // Code for twoButton Label
        
        twoFunctionLabel.text = twoButton.operationString
        twoFunctionLabel.textColor = functionTextColor
        twoFunctionLabel.backgroundColor = functionTitleColor
        twoFunctionLabel.font = functionLabelSize
        twoFunctionLabel.textAlignment = .center
        twoFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(twoFunctionLabel)
        twoFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        twoFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        twoFunctionLabel.centerXAnchor.constraint(equalTo: twoButton.centerXAnchor, constant: 0.0).isActive = true
        twoFunctionLabel.bottomAnchor.constraint(equalTo: twoButton.bottomAnchor, constant: -actualButtonHeight! / 15.0).isActive = true
        
        twoFunctionLabel.layer.cornerRadius = 5
        twoFunctionLabel.clipsToBounds = true
        
        // Code for threeButton Label
        
        threeFunctionLabel.text = threeButton.operationString
        threeFunctionLabel.textColor = functionTextColor
        threeFunctionLabel.backgroundColor = functionTitleColor
        threeFunctionLabel.font = functionLabelSize
        threeFunctionLabel.textAlignment = .center
        threeFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(threeFunctionLabel)
        threeFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        threeFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        threeFunctionLabel.centerXAnchor.constraint(equalTo: threeButton.centerXAnchor, constant: 0.0).isActive = true
        threeFunctionLabel.bottomAnchor.constraint(equalTo: threeButton.bottomAnchor, constant:  -actualButtonHeight! / 15.0).isActive = true
        
        threeFunctionLabel.layer.cornerRadius = 5
        threeFunctionLabel.clipsToBounds = true
        
        // Code for fourButton Label
        
        fourFunctionLabel.text = fourButton.operationString
        fourFunctionLabel.textColor = functionTextColor
        fourFunctionLabel.backgroundColor = functionTitleColor
        fourFunctionLabel.font = functionLabelSize
        fourFunctionLabel.textAlignment = .center
        fourFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fourFunctionLabel)
        fourFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        fourFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        fourFunctionLabel.centerXAnchor.constraint(equalTo: fourButton.centerXAnchor, constant: 0.0).isActive = true
        fourFunctionLabel.bottomAnchor.constraint(equalTo: fourButton.bottomAnchor, constant:  -actualButtonHeight! / 15.0).isActive = true
        
        fourFunctionLabel.layer.cornerRadius = 5
        fourFunctionLabel.clipsToBounds = true
        
        // Code for fiveButton Label
 
        fiveFunctionLabel.text = fiveButton.operationString
        fiveFunctionLabel.textColor = functionTextColor
        fiveFunctionLabel.backgroundColor = functionTitleColor
        fiveFunctionLabel.font = functionLabelSize
        fiveFunctionLabel.textAlignment = .center
        fiveFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fiveFunctionLabel)
        fiveFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        fiveFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        fiveFunctionLabel.centerXAnchor.constraint(equalTo: fiveButton.centerXAnchor, constant: 0.0).isActive = true
        fiveFunctionLabel.bottomAnchor.constraint(equalTo: fiveButton.bottomAnchor, constant:  -actualButtonHeight! / 15.0).isActive = true
        
        fiveFunctionLabel.layer.cornerRadius = 5
        fiveFunctionLabel.clipsToBounds = true
        
        // Code for sixButton Label
        
        sixFunctionLabel.text = sixButton.operationString
        sixFunctionLabel.textColor = functionTextColor
        sixFunctionLabel.backgroundColor = functionTitleColor
        sixFunctionLabel.font = functionLabelSize
        sixFunctionLabel.textAlignment = .center
        sixFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sixFunctionLabel)
        sixFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        sixFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        sixFunctionLabel.centerXAnchor.constraint(equalTo: sixButton.centerXAnchor, constant: 0.0).isActive = true
        sixFunctionLabel.bottomAnchor.constraint(equalTo: sixButton.bottomAnchor, constant: -actualButtonHeight! / 15.0).isActive = true
        
        sixFunctionLabel.layer.cornerRadius = 5
        sixFunctionLabel.clipsToBounds = true
        
        // Code for sevenButton Label
        
        sevenFunctionLabel.text = sevenButton.operationString
        sevenFunctionLabel.textColor = functionTextColor
        sevenFunctionLabel.backgroundColor = functionTitleColor
        sevenFunctionLabel.font = functionLabelSize
        sevenFunctionLabel.textAlignment = .center
        sevenFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sevenFunctionLabel)
        sevenFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        sevenFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        sevenFunctionLabel.centerXAnchor.constraint(equalTo: sevenButton.centerXAnchor, constant: 0.0).isActive = true
        sevenFunctionLabel.bottomAnchor.constraint(equalTo: sevenButton.bottomAnchor, constant:  -actualButtonHeight! / 15.0).isActive = true
        
        sevenFunctionLabel.layer.cornerRadius = 5
        sevenFunctionLabel.clipsToBounds = true
        
        // Code for eightButton Label
        
        eightFunctionLabel.text = eightButton.operationString
        eightFunctionLabel.textColor = functionTextColor
        eightFunctionLabel.backgroundColor = functionTitleColor
        eightFunctionLabel.font = functionLabelSize
        eightFunctionLabel.textAlignment = .center
        eightFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(eightFunctionLabel)
        eightFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.2, constant: 0.0).isActive = true
        eightFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        eightFunctionLabel.centerXAnchor.constraint(equalTo: eightButton.centerXAnchor, constant: 0.0).isActive = true
        eightFunctionLabel.bottomAnchor.constraint(equalTo: eightButton.bottomAnchor, constant: -actualButtonHeight! / 15.0).isActive = true
        
        eightFunctionLabel.layer.cornerRadius = 5
        eightFunctionLabel.clipsToBounds = true
        
        
        // Code for nineButton Label
        
        nineFunctionLabel.text = nineButton.operationString
        nineFunctionLabel.textColor = functionTextColor
        nineFunctionLabel.backgroundColor = functionTitleColor
        nineFunctionLabel.font = functionLabelSize
        nineFunctionLabel.textAlignment = .center
        nineFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nineFunctionLabel)
        nineFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        nineFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        nineFunctionLabel.centerXAnchor.constraint(equalTo: nineButton.centerXAnchor, constant: 0.0).isActive = true
        nineFunctionLabel.bottomAnchor.constraint(equalTo: nineButton.bottomAnchor, constant:  -actualButtonHeight! / 15.0).isActive = true
        
        nineFunctionLabel.layer.cornerRadius = 5
        nineFunctionLabel.clipsToBounds = true
        
    }
    
    func addAllToSubview(){
        addSubview(sRegisterDisplay)
        addSubview(yRegisterDisplay)
        addSubview(lRegisterDisplay)
        addSubview(xRegisterDisplay)
        addSubview(clearButton)
        addSubview(chsButton)
        addSubview(divideButton)
        addSubview(multiplyButton)
        addSubview(minusButton)
        addSubview(plusButton)
        addSubview(enterButton)
        addSubview(decimalButton)
        addSubview(zeroButton)
        addSubview(oneButton)
        addSubview(twoButton)
        addSubview(threeButton)
        addSubview(fourButton)
        addSubview(fiveButton)
        addSubview(sixButton)
        addSubview(sevenButton)
        addSubview(eightButton)
        addSubview(nineButton)

    }
    
}
