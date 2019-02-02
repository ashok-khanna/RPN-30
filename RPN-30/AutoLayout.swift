//
//  CalculatorAutoLayoutExtension.swift
//  RPN-30
//
//  Created by Ashok Khanna on 1/2/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

extension Calculator {
    
    //MARK: Autolayout methods
    
    func setLayout(){
        
        turnOffTranslatesAutoresizing()
        defineSizes()
        anchorConstraints()

    }
    
    func turnOffTranslatesAutoresizing () {
        
        /*
         
         Need to disable the view's autoresizing mark being translated into Auto Layout constraints.
         
         If this property's value is true, the system creates a set of constraints that duplicate the behaviour specified by the view's autoresizing mask. This also lets you modify the view's size and location using the view's frame, bounds or center properties, allowing you to create a static frame-based layout within Auto Layout.
         
         Note that the autoresizing mask constraints fully specify the view's size and position; therefore, you cannot add additional constraints to modify this size or position without introducing conflicts. If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a nonambigious, nonconflicting set of constraints for the view.
         
         By default, the property is set to true for any view you programatically create. If you add views in Interface Builder, the system automatically sets this property to false.
         
         NOTE: Later add comments on how to use frame based layout
         
         */
        
        sRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        yRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        lRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        xRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        chsButton.translatesAutoresizingMaskIntoConstraints = false
        divideButton.translatesAutoresizingMaskIntoConstraints = false
        multiplyButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        decimalButton.translatesAutoresizingMaskIntoConstraints = false
        zeroButton.translatesAutoresizingMaskIntoConstraints = false
        oneButton.translatesAutoresizingMaskIntoConstraints = false
        twoButton.translatesAutoresizingMaskIntoConstraints = false
        threeButton.translatesAutoresizingMaskIntoConstraints = false
        fourButton.translatesAutoresizingMaskIntoConstraints = false
        fiveButton.translatesAutoresizingMaskIntoConstraints = false
        sixButton.translatesAutoresizingMaskIntoConstraints = false
        sevenButton.translatesAutoresizingMaskIntoConstraints = false
        eightButton.translatesAutoresizingMaskIntoConstraints = false
        nineButton.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func defineSizes(){
        // Set UI element widths and heights
        sRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.9, constant: 0.0).isActive = true // One-fourth height
        yRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.5, constant: 0.0).isActive = true // One-fourth height
        lRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.25, constant: 0.0).isActive = true // One-fourth height
        xRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier:  buttonHeight, constant: 0.0).isActive = true
        
        clearButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        chsButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        divideButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        multiplyButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        minusButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        plusButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        enterButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: enterButtonHeight, constant: 0.0).isActive = true // double height
        decimalButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        zeroButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        oneButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        twoButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        threeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        fourButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        fiveButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        sixButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        sevenButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        eightButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        nineButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
        
        sRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        yRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 3.0, constant: 2.0 * buttonHorizontalPadding!).isActive = true // Twice width
        lRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 3.0, constant: buttonHorizontalPadding! * 2.0 - 2.0).isActive = true
        
        xRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0, constant: 0.0).isActive = true // Two-third width
        
        clearButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        chsButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        divideButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        multiplyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        minusButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        plusButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        enterButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        decimalButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        zeroButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 2.0, constant: buttonHorizontalPadding!).isActive = true // double width
        oneButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        twoButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        threeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        fourButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        fiveButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        sixButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        sevenButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        eightButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        nineButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        
    }
    
    func anchorConstraints() {
        
        // Placement of buttons
        
        // Row 0
        sRegisterDisplay.leadingAnchor.constraint(equalTo: yRegisterDisplay.trailingAnchor, constant: buttonHorizontalPadding! ).isActive = true
        sRegisterDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        
        yRegisterDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        yRegisterDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        
        lRegisterDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2.0).isActive = true
        lRegisterDisplay.topAnchor.constraint(equalTo: yRegisterDisplay.bottomAnchor, constant:  buttonVerticalPadding! / 2.0).isActive = true
        
        xRegisterDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        xRegisterDisplay.centerYAnchor.constraint(equalTo: sRegisterDisplay.centerYAnchor, constant: actualButtonHeight! + buttonVerticalPadding!).isActive = true
        
        // Row 1
        clearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        clearButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight! * 2.0 + buttonVerticalPadding! * 2.0).isActive = true
        chsButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        chsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight! * 2.0 + buttonVerticalPadding! * 2.0).isActive = true
        divideButton.leadingAnchor.constraint(equalTo: chsButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        divideButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight! * 2.0 + buttonVerticalPadding! * 2.0).isActive = true
        multiplyButton.leadingAnchor.constraint(equalTo: divideButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        multiplyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight! * 2.0 + buttonVerticalPadding! * 2.0).isActive = true
        
        // Row 2
        sevenButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        sevenButton.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        eightButton.leadingAnchor.constraint(equalTo: sevenButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        eightButton.topAnchor.constraint(equalTo: chsButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        nineButton.leadingAnchor.constraint(equalTo: eightButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        nineButton.topAnchor.constraint(equalTo: divideButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        minusButton.leadingAnchor.constraint(equalTo: nineButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        minusButton.topAnchor.constraint(equalTo: multiplyButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        
        // Row 3
        fourButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        fourButton.topAnchor.constraint(equalTo: sevenButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        fiveButton.leadingAnchor.constraint(equalTo: fourButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        fiveButton.topAnchor.constraint(equalTo: eightButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        sixButton.leadingAnchor.constraint(equalTo: fiveButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        sixButton.topAnchor.constraint(equalTo: nineButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: sixButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        plusButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        
        // Row 4
        oneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        oneButton.topAnchor.constraint(equalTo: fourButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        twoButton.leadingAnchor.constraint(equalTo: oneButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        twoButton.topAnchor.constraint(equalTo: fiveButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        threeButton.leadingAnchor.constraint(equalTo: twoButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        threeButton.topAnchor.constraint(equalTo: sixButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: threeButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        enterButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        
        // Row 5
        zeroButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        zeroButton.topAnchor.constraint(equalTo: oneButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
        decimalButton.leadingAnchor.constraint(equalTo: zeroButton.trailingAnchor, constant: buttonHorizontalPadding!).isActive = true
        decimalButton.topAnchor.constraint(equalTo: threeButton.bottomAnchor, constant: buttonVerticalPadding!).isActive = true
    }
    

}
