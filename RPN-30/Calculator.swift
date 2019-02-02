//
//  Calculator.swift
//  RPN-30
//
//  Created by Ashok Khanna on 19/1/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

// Stackview has its own constraints from autolayout and you can add constraints of subviews heigh, width or aspect ratio. Be careful to avoid introducing conflicts when adding constraints to views inside a stack view. As a general rule of thumb, if a view's size defaults back to its intrinsic content size for a given dimension, you can safely add a constraint for that dimension. You should generally not try to use constraints to change the position of an arranged subview within the stack view, because that will almost certainly cause conflicts. Below guide uses UIView class to show full set of layoutanchor adjustments that you can make

import UIKit

class Calculator: UIView, UITextFieldDelegate {
    
    //MARK: Initialization
    
    // Determine whether entering a digit is for a new number or the existing. Not saved in userdefaults as we want a new entry every time the app is started from scratch.
    var isNewNumberEntry: Bool
    
    //VERY IMPORTANT: Pressing most calculator functions leave the stack left in a state where it will automatically lift. The ENTER key (and CLx which clears the X register) leave the stack in state where it won't automatically lift when the next number is entered. In this case, when the next number is entered it will replace the X register. This may sound complicated but it's really simple and intuitive. The ENTER key copies the X register to Y so there is no reason for the stack to automatically lift when you key the next number. You also wouldn't want the stack to lift after a CLx because that would just insert a zero into the stack. You rarely need to think about this - the calculator just does the right thing.
    
    // Only after an operation is completed AND user has not left the screen should stackAutoLift be set to true. When this occurs entering a new number after an operation results in autolift
    
    var stackAutoLift: Bool
    var storeBalance: Bool
    var recallBalance: Bool
    
    let minimumPressDuration = 0.0
    let longPressRequiredTime = 0.3
    
    //Create UI elements
    let clearButton = CalculatorButton()
    let chsButton = CalculatorButton()
    let divideButton = CalculatorButton()
    let multiplyButton = CalculatorButton()
    let minusButton = CalculatorButton()
    let plusButton = CalculatorButton()
    let enterButton = CalculatorButton()
    let decimalButton = CalculatorButton()
    let zeroButton = CalculatorButton()
    let oneButton = CalculatorButton()
    let twoButton = CalculatorButton()
    let threeButton = CalculatorButton()
    let fourButton = CalculatorButton()
    let fiveButton = CalculatorButton()
    let sixButton = CalculatorButton()
    let sevenButton = CalculatorButton()
    let eightButton = CalculatorButton()
    let nineButton = CalculatorButton()
    
    let zeroFunctionLabel = UILabel()
    let decimalFunctionLabel = UILabel()
    let oneFunctionLabel = UILabel()
    let twoFunctionLabel = UILabel()
    let threeFunctionLabel = UILabel()
    let fourFunctionLabel = UILabel()
    let fiveFunctionLabel = UILabel()
    let sixFunctionLabel = UILabel()
    let sevenFunctionLabel = UILabel()
    let eightFunctionLabel = UILabel()
    let nineFunctionLabel = UILabel()

    let sRegisterDisplay = UILabel()
    let yRegisterDisplay = UILabel()
    let lRegisterDisplay = UILabel()
    let xRegisterDisplay = UILabel()
    
    let lightOrange = UIColor.orange.lighter(by: 25.0)
    let lighterOrange = UIColor.orange.lighter(by: 50.0)
    let lightRed = UIColor.red.lighter(by: 25.0)
    let translucentDarkGray = UIColor.init(white: 1.0 / 3.0, alpha: 0.5)
    let longHighlightColor = UIColor.orange.lighter(by: 25.0)
    
    //Bounds
    
    let numberOfButtonRows = 7.0
    let numberOfButtonCols = 4.0
    let spacingBetweenButtonsAsPercentageOfButton = 0.2
    
    lazy var rowWidth = numberOfButtonCols + (numberOfButtonCols - 1.0) * spacingBetweenButtonsAsPercentageOfButton
    lazy var colHeight = numberOfButtonRows + (numberOfButtonRows - 1.0) * spacingBetweenButtonsAsPercentageOfButton
    lazy var buttonWidth = CGFloat(1.0 / rowWidth)
    lazy var buttonHeight = CGFloat(1.0 / colHeight)
    
    lazy var registerHeight = CGFloat(1.0 / (colHeight * 3.0)) // Zero padding between registers as we will use center alignment vs. calculating appropriate padding
    
    lazy var xRegisterDisplayWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    
    lazy var zeroButtonWidth = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    lazy var enterButtonHeight = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / colHeight)
    lazy var lRegisterWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    
    var actualButtonHeight, actualButtonWidth, buttonHorizontalPadding, buttonVerticalPadding: CGFloat?
    
    // Set spaces between buttons
    // What is CGFloat and how can I use it in constants (see bit later) but also use double there?
    
    // Number formatters
    let formatterDecimal = NumberFormatter()
    let formatterScientific = NumberFormatter() // For displaying numbers in scientific mode
    let formatterXRegister = NumberFormatter() // For showing all decimals for x Register
    let formatterBasic = NumberFormatter()
    
    let maxNumberLengthForLRegister = 999999999.9
    let maxNumberLengthForSRegister = 99999999.9
    let defaultMaximumDecimalsForXRegister = 5
    
    let functionLabelSize = UIFont.systemFont(ofSize: 8.5)
    
    let defaults = UserDefaults.standard
    
    override init(frame: CGRect) { // Used when programatically instantiate view
        self.isNewNumberEntry = true
        self.stackAutoLift = false // User does not expect this behaviour when accessing calculator for first time
        self.storeBalance = false
        self.recallBalance = false
        
        super.init(frame: frame)
        
        actualButtonHeight = self.bounds.height * buttonHeight
        actualButtonWidth = self.bounds.width * buttonWidth
        
        buttonHorizontalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / rowWidth) * self.bounds.width
        
        buttonVerticalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / colHeight) * self.bounds.height
        
        setupNSFormatters()

    }
    
    required init?(coder aDecoder: NSCoder) { // Used when instantiating via storyboard
        //  fatalError("init(coder:) has not been implemented")
        self.isNewNumberEntry = true
        self.stackAutoLift = false // User does not expect this behaviour when accessing calculator for first time
        self.storeBalance = false
        self.recallBalance = false

        super.init(coder: aDecoder)

        actualButtonHeight = self.bounds.height * buttonHeight
        actualButtonWidth = self.bounds.width * buttonWidth
        
        
        setupNSFormatters()
        formatterXRegister.numberStyle = .decimal

    }
    
     func setupCalculator(){
        
        initButtons()

        setLayout()
        
        formatCalculator()
        
        self.layoutIfNeeded()

        clearStack()
        clearLastRegisters()
        updateDisplays(afterOperation: false, onClear: true)
        
        addTargets()
  
    }
    
}

