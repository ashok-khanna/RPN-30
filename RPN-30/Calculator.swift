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
    
    
    //Create global variable for starting position of longPress (of button) that is set every time a button long gesture begins
    var longPressStartPoint: CGPoint?
    var longPressStartTime: TimeInterval?
    var longPressEndTime: TimeInterval?
    let maximumDistance = 30
    let minimumPressDuration = 0.0
    let longGestureStartTime = 0.0
    
    //Create UI elements
    let deleteButton = CalculatorButton()
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

    let tzRegisterDisplay = UILabel()
    let yRegisterDisplay = UILabel()
    let yRegisterDisplayBox = UILabel()
    let lRegisterDisplay = UILabel()
    let functionDisplay = UILabel()
    let mainDisplay = UILabel()
    let cancelLabel = UILabel()
    
    let displayTextfield = UITextField()
    
    let lightOrange = UIColor.orange.lighter(by: 25.0)
    let lighterOrange = UIColor.orange.lighter(by: 50.0)
    let lightRed = UIColor.red.lighter(by: 25.0)
    
    let formatterXRegister = NumberFormatter() // For showing all decimals for x Register
    let formatterLYRegister = NumberFormatter() // For showing only accepted number of decimals for Y L registers
    let formatterLXRegister = NumberFormatter()
    let formatterDecimal = NumberFormatter() // For adding commas into the numbers
    let formatterScientific = NumberFormatter() // For displaying numbers in scientific mode
    
    let functionLabelSize = UIFont.systemFont(ofSize: 8.5)
    
    let stackRegisterDisplaySize = 999999.9
    
    // Set color for function titles

    
    let defaults = UserDefaults.standard
    var stackRegisters: [Double]
    
    override init(frame: CGRect) {
        self.isNewNumberEntry = true
        self.stackAutoLift = false // User does not expect this behaviour when accessing calculator for first time
        self.storeBalance = false
        self.recallBalance = false
        self.stackRegisters = [Double]()
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        defaults.set(self.stackRegisters, forKey: "stackRegisters")
        
        super.init(frame: frame)

        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //  fatalError("init(coder:) has not been implemented")
        self.isNewNumberEntry = true
        self.stackAutoLift = false // User does not expect this behaviour when accessing calculator for first time
        self.storeBalance = false
        self.recallBalance = false
        self.stackRegisters = [Double]()
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        defaults.set(self.stackRegisters, forKey: "stackRegisters")

        super.init(coder: aDecoder)

        formatterScientific.numberStyle = .scientific
        formatterScientific.usesSignificantDigits = true
        formatterDecimal.numberStyle = .decimal
        formatterXRegister.numberStyle = .decimal
        formatterLYRegister.numberStyle = .decimal // Add commas after 000s to numbers
        formatterLXRegister.numberStyle = .decimal
        setupButtons()
    }
    
    //MARK: Private Methods
    
    private func setupButtons(){
        
        // self.backgroundColor = UIColor.black
        
        displayTextfield.delegate = self
        displayTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        displayTextfield.returnKeyType = UIReturnKeyType.done
        
        //rdisplayTextfield.isDar
        
        //Initialise button values
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
        
        //Initialise states for digits
        oneButton.states = ["EE"]
        twoButton.states = ["√"]
        threeButton.states = ["1/x"]
        fourButton.states = ["%"]
        fiveButton.states = ["% Δ"]
        sixButton.states = ["% T"]
        sevenButton.states = ["e^x"]
        eightButton.states = ["ln x"]
        nineButton.states = ["y^x"]
        
        // Set font size for main digits
        let digitTitleSize = UIFont.boldSystemFont(ofSize: 22.5)
        
        // Set font size for first row buttons
        let textTitleSize = UIFont.boldSystemFont(ofSize: 18.0)
        
        // Set font size for function button
        let functionFontSize = UIFont.systemFont(ofSize: 20.0)
        
        // Set font size for symbol buttons
        let symbolTitleSize = UIFont.systemFont(ofSize: 30.0)
        
        // Set font size for function titles
        let functionTitleSize = UIFont.systemFont(ofSize: 8.5)
        
        // let functionTitleColor = UIColor(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
        let functionTitleColor = UIColor.lightGray
        let functionTextColor = UIColor.black
        
        // Set highlight colors
        

        
        clearButton.highlightColor = UIColor.white
        chsButton.highlightColor = UIColor.white
        divideButton.highlightColor = UIColor.white
        multiplyButton.highlightColor = UIColor.orange.lighter(by: 50.0)
        minusButton.highlightColor = UIColor.orange.lighter(by: 50.0)
        plusButton.highlightColor = UIColor.orange.lighter(by: 50.0)
        enterButton.highlightColor = UIColor.orange.lighter(by: 50.0)
        
        
        // Set font sizes, colors and alignments for output display
        tzRegisterDisplay.textAlignment = .center
        yRegisterDisplay.textAlignment = .left
        lRegisterDisplay.textAlignment = .left
        functionDisplay.textAlignment = .center
        mainDisplay.textAlignment = .center
        
        tzRegisterDisplay.textColor = .white
        lRegisterDisplay.textColor = .darkGray
        
        yRegisterDisplay.textColor = .white
        functionDisplay.textColor = .darkGray
        mainDisplay.textColor = .white
        
        tzRegisterDisplay.font = UIFont.systemFont(ofSize: 9.0)
        tzRegisterDisplay.numberOfLines = 0
        lRegisterDisplay.font = UIFont.systemFont(ofSize: 14.0)
        cancelLabel.font = UIFont.systemFont(ofSize: 10.0)
        
        cancelLabel.text = "UNDO"
        cancelLabel.adjustsFontSizeToFitWidth = true
        cancelLabel.textAlignment = .center
        cancelLabel.textColor = .black
        
        yRegisterDisplay.font = UIFont.systemFont(ofSize: 30.0)
        functionDisplay.font = UIFont.systemFont(ofSize: 10.0)
        mainDisplay.font = UIFont.systemFont(ofSize: 40.0)
        tzRegisterDisplay.adjustsFontSizeToFitWidth = true
        yRegisterDisplay.adjustsFontSizeToFitWidth = true
        lRegisterDisplay.adjustsFontSizeToFitWidth = true
        functionDisplay.adjustsFontSizeToFitWidth = true
        mainDisplay.adjustsFontSizeToFitWidth = true
        
        // Set colors for UI elements
        
        tzRegisterDisplay.backgroundColor = UIColor.init(white: 1.0 / 3.0, alpha: 0.25)
       // lRegisterDisplay.backgroundColor = UIColor.black
       // cancelLabel.backgroundColor = UIColor.black
        
       // yRegisterDisplay.backgroundColor = UIColor.black
        functionDisplay.backgroundColor = UIColor.lightGray
        // mainDisplay.backgroundColor = UIColor.black
        
        let translucentOrange = UIColor.init(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5)
        let translucentDarkGray = UIColor.init(white: 1.0 / 3.0, alpha: 0.5)
        let translucentLightGray = UIColor.init(white: 2.0 / 3.0, alpha: 0.5)
        
        deleteButton.backgroundColor = translucentLightGray
        clearButton.backgroundColor = translucentLightGray
        chsButton.backgroundColor = translucentLightGray
        divideButton.backgroundColor = translucentLightGray
        
        multiplyButton.backgroundColor = translucentOrange
        minusButton.backgroundColor = translucentOrange
        plusButton.backgroundColor = translucentOrange
        enterButton.backgroundColor = translucentOrange
        
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

        // Textfield adjustments
        mainDisplay.isUserInteractionEnabled = true
        // displayTextfield.keyboardAppearance = .dark

        /*
         
         Need to disable the view's autoresizing mark being translated into Auto Layout constraints.
         
         If this property's value is true, the system creates a set of constraints that duplicate the behaviour specified by the view's autoresizing mask. This also lets you modify the view's size and location using the view's frame, bounds or center properties, allowing you to create a static frame-based layout within Auto Layout.
         
         Note that the autoresizing mask constraints fully specify the view's size and position; therefore, you cannot add additional constraints to modify this size or position without introducing conflicts. If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a nonambigious, nonconflicting set of constraints for the view.
         
         By default, the property is set to true for any view you programatically create. If you add views in Interface Builder, the system automatically sets this property to false.
         
         NOTE: Later add comments on how to use frame based layout
         
         */
        
        tzRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        yRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        lRegisterDisplay.translatesAutoresizingMaskIntoConstraints = false
        functionDisplay.translatesAutoresizingMaskIntoConstraints = false
        mainDisplay.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        // Add UI elements to the view
        addSubview(tzRegisterDisplay)
        addSubview(yRegisterDisplay)
        addSubview(lRegisterDisplay)
        addSubview(functionDisplay)
        addSubview(mainDisplay)
        addSubview(deleteButton)
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
        addSubview(cancelLabel)
        addSubview(displayTextfield)
        
        
        /*
            Set positions of buttons
            How to know if constraints are nonambigious
            Set names for constraints
        */
        
        // Make buttons round
        // clearButton.layer.cornerRadius = 0.5 * clearButton.width
        
        let numberOfButtonRows = 7.0
        let numberOfButtonCols = 4.0
        
        let spacingBetweenButtonsAsPercentageOfButton = 0.2
        
        let rowWidth = numberOfButtonCols + (numberOfButtonCols - 1.0) * spacingBetweenButtonsAsPercentageOfButton
        
        let colHeight = numberOfButtonRows + (numberOfButtonRows - 1.0) * spacingBetweenButtonsAsPercentageOfButton
        
        let buttonWidth = CGFloat(1.0 / rowWidth)
        let buttonHeight = CGFloat(1.0 / colHeight)
        
        let registerHeight = CGFloat(1.0 / (colHeight * 3.0)) // Zero padding between registers as we will use center alignment vs. calculating appropriate padding
        
        let mainDisplayWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)

        let zeroButtonWidth = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
        let enterButtonHeight = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / colHeight)
        let lRegisterWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
        
        // Set spaces between buttons
        // What is CGFloat and how can I use it in constants (see bit later) but also use double there?

        let actualButtonHeight = self.bounds.height * buttonHeight
        let actualButtonWidth = self.bounds.width * buttonWidth
        
        let buttonHorizontalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / rowWidth) * self.bounds.width
        
        let buttonVerticalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / colHeight) * self.bounds.height
        
              //  let mainDisplayHeight = (1.0 * registerHeight * self.bounds.size.height) // Zero padding between registers as we will use right alignment vs calculating appropriate padding
        
        // Make lregister layer on top
        self.bringSubviewToFront(lRegisterDisplay)
        
        // Set UI element widths and heights
        tzRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.9, constant: 0.0).isActive = true // One-fourth height
        yRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.5, constant: 0.0).isActive = true // One-fourth height
        lRegisterDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.25, constant: 0.0).isActive = true // One-fourth height
        cancelLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.5, constant: 0.0).isActive = true // One-fourth height
        
        functionDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.0, constant: 0.0).isActive = true
        mainDisplay.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier:  buttonHeight, constant: 0.0).isActive = true
        
        deleteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight, constant: 0.0).isActive = true
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
        
        tzRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        yRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 3.0, constant: 2.0 * buttonHorizontalPadding).isActive = true // Twice width
        lRegisterDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 3.0, constant: buttonHorizontalPadding * 2.0 - 2.0).isActive = true
        cancelLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: buttonHorizontalPadding * 0.0).isActive = true
        functionDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.0, constant: 0.0).isActive = true // One-third width
        mainDisplay.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0, constant: 0.0).isActive = true // Two-third width
        
        deleteButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.0, constant: 0.0).isActive = true
        clearButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        chsButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        divideButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        multiplyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        minusButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        plusButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        enterButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        decimalButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        zeroButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 2.0, constant: buttonHorizontalPadding).isActive = true // double width
        oneButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        twoButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        threeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        fourButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        fiveButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        sixButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        sevenButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        eightButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        nineButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth, constant: 0.0).isActive = true
        
        

        // Placement of buttons
        
        // Row 0A
        tzRegisterDisplay.leadingAnchor.constraint(equalTo: yRegisterDisplay.trailingAnchor, constant: buttonHorizontalPadding ).isActive = true
        tzRegisterDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        
        yRegisterDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        
        lRegisterDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2.0).isActive = true
        lRegisterDisplay.topAnchor.constraint(equalTo: yRegisterDisplay.bottomAnchor, constant:  buttonVerticalPadding / 2.0).isActive = true
        
        cancelLabel.leadingAnchor.constraint(equalTo: lRegisterDisplay.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        cancelLabel.topAnchor.constraint(equalTo: yRegisterDisplay.bottomAnchor, constant: buttonVerticalPadding / 2.0).isActive = true
        
        yRegisterDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
       // functionDisplay.topAnchor.constraint(equalTo: yRegisterDisplay.bottomAnchor, constant: buttonVerticalPadding / 2.0).isActive = true
        
      //  functionDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true


        // Row 0B
        
        mainDisplay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true

        deleteButton.leadingAnchor.constraint(equalTo: yRegisterDisplay.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        mainDisplay.topAnchor.constraint(equalTo: tzRegisterDisplay.bottomAnchor, constant: buttonVerticalPadding * 0.5).isActive = true
        // mainDisplay.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Row 1
        clearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        clearButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight * 2.0 + buttonVerticalPadding * 2.0).isActive = true
        chsButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        chsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight * 2.0 + buttonVerticalPadding * 2.0).isActive = true
        divideButton.leadingAnchor.constraint(equalTo: chsButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        divideButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight * 2.0 + buttonVerticalPadding * 2.0).isActive = true
        multiplyButton.leadingAnchor.constraint(equalTo: divideButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        multiplyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: actualButtonHeight * 2.0 + buttonVerticalPadding * 2.0).isActive = true
        
        // Row 2
        sevenButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        sevenButton.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        eightButton.leadingAnchor.constraint(equalTo: sevenButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        eightButton.topAnchor.constraint(equalTo: chsButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        nineButton.leadingAnchor.constraint(equalTo: eightButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        nineButton.topAnchor.constraint(equalTo: divideButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        minusButton.leadingAnchor.constraint(equalTo: nineButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        minusButton.topAnchor.constraint(equalTo: multiplyButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        
        // Row 3
        fourButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        fourButton.topAnchor.constraint(equalTo: sevenButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        fiveButton.leadingAnchor.constraint(equalTo: fourButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        fiveButton.topAnchor.constraint(equalTo: eightButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        sixButton.leadingAnchor.constraint(equalTo: fiveButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        sixButton.topAnchor.constraint(equalTo: nineButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: sixButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        plusButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        
        // Row 4
        oneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        oneButton.topAnchor.constraint(equalTo: fourButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        twoButton.leadingAnchor.constraint(equalTo: oneButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        twoButton.topAnchor.constraint(equalTo: fiveButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        threeButton.leadingAnchor.constraint(equalTo: twoButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        threeButton.topAnchor.constraint(equalTo: sixButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: threeButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        enterButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        
        // Row 5
        zeroButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        zeroButton.topAnchor.constraint(equalTo: oneButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        decimalButton.leadingAnchor.constraint(equalTo: zeroButton.trailingAnchor, constant: buttonHorizontalPadding).isActive = true
        decimalButton.topAnchor.constraint(equalTo: threeButton.bottomAnchor, constant: buttonVerticalPadding).isActive = true
        
        // Need to research, but this is needed to make buttons round - auto layout has three stages (layer is one)
        self.layoutIfNeeded()
        
       for case let button as CalculatorButton in self.subviews  {
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
        
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        
        tzRegisterDisplay.layer.cornerRadius = 8.75
        tzRegisterDisplay.clipsToBounds = true
        
        functionDisplay.layer.cornerRadius = 7.5
        functionDisplay.clipsToBounds = true
        
        // Add text to buttons
 
        
        // NSMutableAttributedStrings are used to store strings with formatting
        var myMutableString = NSMutableAttributedString()
        
        // Need to add alignment
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        // Text labels for operations buttons
        myMutableString = NSMutableAttributedString(string: "DEL", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: textTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        deleteButton.setAttributedTitle(myMutableString, for: .normal)
        
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
        
        let decimalFunctionLabel = UILabel()
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
        decimalFunctionLabel.centerYAnchor.constraint(equalTo: decimalButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        decimalFunctionLabel.layer.cornerRadius = 5
        decimalFunctionLabel.clipsToBounds = true
        
        // Code for zeroButton Label
        
        let zeroFunctionLabel = UILabel()
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
        zeroFunctionLabel.centerYAnchor.constraint(equalTo: zeroButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        zeroFunctionLabel.layer.cornerRadius = 5
        zeroFunctionLabel.clipsToBounds = true
        
        // Code for oneButton Label
        
        let oneFunctionLabel = UILabel()
        oneFunctionLabel.text = "EE"
        oneFunctionLabel.textColor = functionTextColor
        oneFunctionLabel.backgroundColor = functionTitleColor
        oneFunctionLabel.font = functionLabelSize
        oneFunctionLabel.textAlignment = .center
        oneFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(oneFunctionLabel)
        oneFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        oneFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        oneFunctionLabel.centerXAnchor.constraint(equalTo: oneButton.centerXAnchor, constant: 0.0).isActive = true
        oneFunctionLabel.centerYAnchor.constraint(equalTo: oneButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        oneFunctionLabel.layer.cornerRadius = 5
        oneFunctionLabel.clipsToBounds = true
        
        // Code for twoButton Label
        
        let twoFunctionLabel = UILabel()
        twoFunctionLabel.text = "√"
        twoFunctionLabel.textColor = functionTextColor
        twoFunctionLabel.backgroundColor = functionTitleColor
        twoFunctionLabel.font = functionLabelSize
        twoFunctionLabel.textAlignment = .center
        twoFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(twoFunctionLabel)
        twoFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        twoFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        twoFunctionLabel.centerXAnchor.constraint(equalTo: twoButton.centerXAnchor, constant: 0.0).isActive = true
        twoFunctionLabel.centerYAnchor.constraint(equalTo: twoButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        twoFunctionLabel.layer.cornerRadius = 5
        twoFunctionLabel.clipsToBounds = true
        
        // Code for threeButton Label
        
        let threeFunctionLabel = UILabel()
        threeFunctionLabel.text = "1/x"
        threeFunctionLabel.textColor = functionTextColor
        threeFunctionLabel.backgroundColor = functionTitleColor
        threeFunctionLabel.font = functionLabelSize
        threeFunctionLabel.textAlignment = .center
        threeFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(threeFunctionLabel)
        threeFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        threeFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        threeFunctionLabel.centerXAnchor.constraint(equalTo: threeButton.centerXAnchor, constant: 0.0).isActive = true
        threeFunctionLabel.centerYAnchor.constraint(equalTo: threeButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        threeFunctionLabel.layer.cornerRadius = 5
        threeFunctionLabel.clipsToBounds = true
        
        // Code for fourButton Label
        
        let fourFunctionLabel = UILabel()
        fourFunctionLabel.text = "%"
        fourFunctionLabel.textColor = functionTextColor
        fourFunctionLabel.backgroundColor = functionTitleColor
        fourFunctionLabel.font = functionLabelSize
        fourFunctionLabel.textAlignment = .center
        fourFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fourFunctionLabel)
        fourFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        fourFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        fourFunctionLabel.centerXAnchor.constraint(equalTo: fourButton.centerXAnchor, constant: 0.0).isActive = true
        fourFunctionLabel.centerYAnchor.constraint(equalTo: fourButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        fourFunctionLabel.layer.cornerRadius = 5
        fourFunctionLabel.clipsToBounds = true
        
        // Code for fiveButton Label
        
        let fiveFunctionLabel = UILabel()
        fiveFunctionLabel.text = "% Δ"
        fiveFunctionLabel.textColor = functionTextColor
        fiveFunctionLabel.backgroundColor = functionTitleColor
        fiveFunctionLabel.font = functionLabelSize
        fiveFunctionLabel.textAlignment = .center
        fiveFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fiveFunctionLabel)
        fiveFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        fiveFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        fiveFunctionLabel.centerXAnchor.constraint(equalTo: fiveButton.centerXAnchor, constant: 0.0).isActive = true
        fiveFunctionLabel.centerYAnchor.constraint(equalTo: fiveButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        fiveFunctionLabel.layer.cornerRadius = 5
        fiveFunctionLabel.clipsToBounds = true
        
        // Code for sixButton Label
        
        let sixFunctionLabel = UILabel()
        sixFunctionLabel.text = "% T"
        sixFunctionLabel.textColor = functionTextColor
        sixFunctionLabel.backgroundColor = functionTitleColor
        sixFunctionLabel.font = functionLabelSize
        sixFunctionLabel.textAlignment = .center
        sixFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sixFunctionLabel)
        sixFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        sixFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        sixFunctionLabel.centerXAnchor.constraint(equalTo: sixButton.centerXAnchor, constant: 0.0).isActive = true
        sixFunctionLabel.centerYAnchor.constraint(equalTo: sixButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        sixFunctionLabel.layer.cornerRadius = 5
        sixFunctionLabel.clipsToBounds = true
        
        // Code for sevenButton Label
        
        let sevenFunctionLabel = UILabel()
        sevenFunctionLabel.text = "e^x"
        sevenFunctionLabel.textColor = functionTextColor
        sevenFunctionLabel.backgroundColor = functionTitleColor
        sevenFunctionLabel.font = functionLabelSize
        sevenFunctionLabel.textAlignment = .center
        sevenFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sevenFunctionLabel)
        sevenFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        sevenFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        sevenFunctionLabel.centerXAnchor.constraint(equalTo: sevenButton.centerXAnchor, constant: 0.0).isActive = true
        sevenFunctionLabel.centerYAnchor.constraint(equalTo: sevenButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        sevenFunctionLabel.layer.cornerRadius = 5
        sevenFunctionLabel.clipsToBounds = true
        
        // Code for eightButton Label
        
        let eightFunctionLabel = UILabel()
        eightFunctionLabel.text = "ln x"
        eightFunctionLabel.textColor = functionTextColor
        eightFunctionLabel.backgroundColor = functionTitleColor
        eightFunctionLabel.font = functionLabelSize
        eightFunctionLabel.textAlignment = .center
        eightFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(eightFunctionLabel)
        eightFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        eightFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        eightFunctionLabel.centerXAnchor.constraint(equalTo: eightButton.centerXAnchor, constant: 0.0).isActive = true
        eightFunctionLabel.centerYAnchor.constraint(equalTo: eightButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        eightFunctionLabel.layer.cornerRadius = 5
        eightFunctionLabel.clipsToBounds = true
        
        
        // Code for nineButton Label
        
        let nineFunctionLabel = UILabel()
        nineFunctionLabel.text = "y^x"
        nineFunctionLabel.textColor = functionTextColor
        nineFunctionLabel.backgroundColor = functionTitleColor
        nineFunctionLabel.font = functionLabelSize
        nineFunctionLabel.textAlignment = .center
        nineFunctionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nineFunctionLabel)
        nineFunctionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: buttonHeight * 0.20, constant: 0.0).isActive = true
        nineFunctionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidth * 0.5, constant: 0.0).isActive = true
        
        nineFunctionLabel.centerXAnchor.constraint(equalTo: nineButton.centerXAnchor, constant: 0.0).isActive = true
        nineFunctionLabel.centerYAnchor.constraint(equalTo: nineButton.centerYAnchor, constant: 1.75 * actualButtonHeight / 5.0).isActive = true
        
        nineFunctionLabel.layer.cornerRadius = 5
        nineFunctionLabel.clipsToBounds = true
        

        yRegisterDisplay.layer.cornerRadius = 8.75
        yRegisterDisplay.clipsToBounds = true
        
        lRegisterDisplay.layer.cornerRadius = 8.75
        lRegisterDisplay.clipsToBounds = true

        cancelLabel.layer.cornerRadius = 8.75
        cancelLabel.clipsToBounds = true

        
        updateDisplays()
        addTargets()
  
    }
    
    private func addTargets(){
 

        
        
        //Add short gestures
    
        let mainDisplayShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteInput))
        mainDisplayShortTapGesture.numberOfTapsRequired = 1
        mainDisplay.addGestureRecognizer(mainDisplayShortTapGesture)
        
        let enterTapGesture = UITapGestureRecognizer(target: self, action: #selector(enterInput))
        enterTapGesture.numberOfTapsRequired = 1
        enterButton.addGestureRecognizer(enterTapGesture)
        
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(plusInput))
        plusTapGesture.numberOfTapsRequired = 1
        plusButton.addGestureRecognizer(plusTapGesture)
        
        let minusTapGesture = UITapGestureRecognizer(target: self, action: #selector(minusInput))
        minusTapGesture.numberOfTapsRequired = 1
        minusButton.addGestureRecognizer(minusTapGesture)
        
        let multiplyTapGesture = UITapGestureRecognizer(target: self, action: #selector(multiplyInput))
        multiplyTapGesture.numberOfTapsRequired = 1
        multiplyButton.addGestureRecognizer(multiplyTapGesture)
        
        let divideTapGesture = UITapGestureRecognizer(target: self, action: #selector(divideInput))
        divideTapGesture.numberOfTapsRequired = 1
        divideButton.addGestureRecognizer(divideTapGesture)
        
        let chsTapGesture = UITapGestureRecognizer(target: self, action: #selector(chsInput))
        chsTapGesture.numberOfTapsRequired = 1
        chsButton.addGestureRecognizer(chsTapGesture)
        
        let clearTapGesture = UITapGestureRecognizer(target: self, action: #selector(clearInput))
        clearTapGesture.numberOfTapsRequired = 1
        clearButton.addGestureRecognizer(clearTapGesture)
        
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteInput))
        deleteTapGesture.numberOfTapsRequired = 1
        deleteButton.addGestureRecognizer(deleteTapGesture)
        
        let cancelTapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelInput))
        cancelTapGesture.numberOfTapsRequired = 1
        cancelLabel.addGestureRecognizer(cancelTapGesture)
        cancelLabel.isUserInteractionEnabled = true
        
        let registerTapGestureOne = UITapGestureRecognizer(target: self, action: #selector(registerInputOne))
        
        let registerTapGestureTwo = UITapGestureRecognizer(target: self, action: #selector(registerInputTwo))

        let registerTapGestureThree = UITapGestureRecognizer(target: self, action: #selector(registerInputThree))
        
        registerTapGestureOne.numberOfTapsRequired = 1
        registerTapGestureTwo.numberOfTapsRequired = 2
        registerTapGestureThree.numberOfTapsRequired = 3
        
        registerTapGestureOne.require(toFail: registerTapGestureTwo)
        registerTapGestureTwo.require(toFail: registerTapGestureThree)
        
        tzRegisterDisplay.addGestureRecognizer(registerTapGestureOne)
        tzRegisterDisplay.isUserInteractionEnabled = true
        tzRegisterDisplay.addGestureRecognizer(registerTapGestureTwo)
        tzRegisterDisplay.addGestureRecognizer(registerTapGestureThree)


        
        // Configure long gestures
        
        let decimalLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(decimalButtonLongAction(gesture:)))
        decimalLongTapGesture.minimumPressDuration = minimumPressDuration
        decimalButton.addGestureRecognizer(decimalLongTapGesture)
        
        let zeroLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(zeroButtonLongAction(gesture:)))
        zeroLongTapGesture.minimumPressDuration = minimumPressDuration
        zeroButton.addGestureRecognizer(zeroLongTapGesture)
        
        let oneLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(oneButtonLongAction(gesture:)))
        oneLongTapGesture.minimumPressDuration = minimumPressDuration
        oneButton.addGestureRecognizer(oneLongTapGesture)
        
        let twoLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(twoButtonLongAction(gesture:)))
        twoLongTapGesture.minimumPressDuration = minimumPressDuration
        twoButton.addGestureRecognizer(twoLongTapGesture)
        
        let threeLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(threeButtonLongAction(gesture:)))
        threeLongTapGesture.minimumPressDuration = minimumPressDuration
        threeButton.addGestureRecognizer(threeLongTapGesture)
        
        let fourLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(fourButtonLongAction(gesture:)))
        fourLongTapGesture.minimumPressDuration = minimumPressDuration
        fourButton.addGestureRecognizer(fourLongTapGesture)
        
        let fiveLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(fiveButtonLongAction(gesture:)))
        fiveLongTapGesture.minimumPressDuration = minimumPressDuration
        fiveButton.addGestureRecognizer(fiveLongTapGesture)
        
        let sixLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(sixButtonLongAction(gesture:)))
        sixLongTapGesture.minimumPressDuration = minimumPressDuration
        sixButton.addGestureRecognizer(sixLongTapGesture)
        
        let sevenLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(sevenButtonLongAction(gesture:)))
        sevenLongTapGesture.minimumPressDuration = minimumPressDuration
        sevenButton.addGestureRecognizer(sevenLongTapGesture)
        
        let eightLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(eightButtonLongAction(gesture:)))
        eightLongTapGesture.minimumPressDuration = minimumPressDuration
        eightButton.addGestureRecognizer(eightLongTapGesture)
        
        let nineLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(nineButtonLongAction(gesture:)))
        nineLongTapGesture.minimumPressDuration = minimumPressDuration
        nineButton.addGestureRecognizer(nineLongTapGesture)
        
        let clearLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(clearButtonLongAction(gesture:)))
        clearLongTapGesture.minimumPressDuration = minimumPressDuration
        clearButton.addGestureRecognizer(clearLongTapGesture)
        
        
        // Prevent conflicts of buttons for zero / decimal and digits
        /*
        oneShortTapGesture.require(toFail: zeroShortTapGesture)
        oneShortTapGesture.require(toFail: decimalShortTapGesture)
        
        twoShortTapGesture.require(toFail: zeroShortTapGesture)
        twoShortTapGesture.require(toFail: decimalShortTapGesture)
        
        threeShortTapGesture.require(toFail: zeroShortTapGesture)
        threeShortTapGesture.require(toFail: decimalShortTapGesture)
        
        fourShortTapGesture.require(toFail: zeroShortTapGesture)
        fourShortTapGesture.require(toFail: decimalShortTapGesture)
        
        fiveShortTapGesture.require(toFail: zeroShortTapGesture)
        fiveShortTapGesture.require(toFail: decimalShortTapGesture)
        
        sixShortTapGesture.require(toFail: zeroShortTapGesture)
        sixShortTapGesture.require(toFail: decimalShortTapGesture)
        
        sevenShortTapGesture.require(toFail: zeroShortTapGesture)
        sevenShortTapGesture.require(toFail: decimalShortTapGesture)
        
        eightShortTapGesture.require(toFail: zeroShortTapGesture)
        eightShortTapGesture.require(toFail: decimalShortTapGesture)
        
        nineShortTapGesture.require(toFail: zeroShortTapGesture)
        nineShortTapGesture.require(toFail: decimalShortTapGesture)
 */
  
    }
    
    // Textfield delegate methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if displayTextfield.isEditing {
            displayTextfield.text = ""
            mainDisplay.text = ""
            self.displayTextfield.endEditing(true)
            
        }
        
    }
    
    @objc func textFieldDidChange () {
        mainDisplay.text = displayTextfield.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        displayTextfield.resignFirstResponder()
        
        if let number = Double(textField.text!) {
            
            if stackAutoLift {
                liftStackRegisters()
                stackAutoLift = false
                clearLastRegisters()
                updateLastDisplay()
            }
            
            if isNewNumberEntry {
                amendStackRegister(value: 0.0, at: 0)
                isNewNumberEntry = false
                UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
            }
            
            amendStackRegister(value: number, at: 0)
            defaults.set(number, forKey: "lRegisterX")
            updateNumberDisplay()
        } else {
            let buttonOperation = textField.text ?? ""
            processInput(buttonOperation)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // Short gestures code
    
    @objc private func mainDisplayInput(){
        mainDisplay.text = ""
        displayTextfield.becomeFirstResponder()
    }
    
    @objc private func zeroInput(){
        numberInput(zeroButton)
    }
    
    @objc private func oneInput(){
        numberInput(oneButton)
    }
    
    @objc private func twoInput(){
        numberInput(twoButton)
    }
    
    @objc private func threeInput(){
        numberInput(threeButton)
    }
    @objc private func fourInput(){
        numberInput(fourButton)
    }
    
    @objc private func fiveInput(){
        numberInput(fiveButton)
    }
    
    @objc private func sixInput(){
        numberInput(sixButton)
    }
    
    @objc private func sevenInput(){
        numberInput(sevenButton)
    }
    
    @objc private func eightInput(){
        numberInput(eightButton)
    }
    
    @objc private func nineInput(){
        numberInput(nineButton)
    }
    
    
    @objc private func plusInput(){
        basicOperator("+")
    }
    
    @objc private func minusInput(){
        basicOperator("−")
    }
    
    @objc private func multiplyInput(){
        basicOperator("x")
    }
    
    @objc private func divideInput(){
        basicOperator("÷")
    }
    
    @objc private func chsInput(){
        basicOperator("chs")
    }
    
    @objc private func registerInputOne(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[2]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc private func registerInputTwo(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[3]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc private func registerInputThree(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[4]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc private func cancelInput(){
        var stackRegisters = [Double]()
        var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        
        stackRegisters.append(defaults.double(forKey: "lRegisterX"))
        stackRegisters.append(defaults.double(forKey: "lRegisterY"))
       

        stackRegistersOld.removeFirst()
        stackRegisters.append(contentsOf: stackRegistersOld)
        defaults.set(stackRegisters, forKey: "stackRegisters")
    
        defaults.set(0.0, forKey: "lRegisterY")
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")

        updateDisplays()
    }

    
    //MARK: Long press functions
    
    private func calculateButtonStage(timeInterval: TimeInterval, numberOfStages: Int) -> Int {
        
        if numberOfStages == 0 {
            return 0
        } else {
            let modifiedTimeValue = (timeInterval / (minimumPressDuration * Double(numberOfStages))).truncatingRemainder(dividingBy: 1.0)
            for index in 0...(numberOfStages - 1) {
                if (modifiedTimeValue > (Double(index) / Double(numberOfStages))) && (modifiedTimeValue <= (Double(index + 1) / Double(numberOfStages))) {
                    return index
                }
            }
            return 0
        }
    }
    
    private func completeOperation(button: CalculatorButton, gesture: UILongPressGestureRecognizer) {
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - button.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            button.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            
            button.highlightColor = .lightGray
            button.isHighlighted = true
            
        case .changed:
            if longPressEndTime > 0.5 {
                button.highlightColor = lightOrange
                button.isHighlighted = true
                
                if !(storeBalance || recallBalance){
                    let stateIndex = calculateButtonStage(timeInterval: longPressEndTime, numberOfStages: button.states!.count)
                    updateFunctionDisplay2(button: button, stateIndex: stateIndex)
                    
                } else {
                    button.highlightColor = .lightGray
                    button.isHighlighted = true
                }
            }

            
        case .ended:

            if longPressEndTime > 0.5 {
                if !(storeBalance || recallBalance){
                    let stateIndex = calculateButtonStage(timeInterval: longPressEndTime, numberOfStages: button.states!.count)
                    // updateFunctionDisplay(button: button, stateIndex: stateIndex)
                    button.isHighlighted = false
                    button.highlightColor = .lightGray
                    
                    let buttonOperation = button.states?[stateIndex] ?? ""
                    processInput(buttonOperation)
                    return
                }
            } else {
                button.highlightColor = .lightGray
                button.isHighlighted = false
                numberInput(button)
            }
  
        default:
            break
        }
    }

    
    @objc private func decimalButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - decimalButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            decimalButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            decimalButton.highlightColor = .lightGray
            decimalButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > 0.5 {
                decimalButton.highlightColor = lightRed
                decimalButton.isHighlighted = true
                orangeDigits()
                recallBalance = true
                
            } else {
                decimalButton.highlightColor = .lightGray
                decimalButton.isHighlighted = true
            }
            
        case .ended:
            
            if longPressEndTime > 0.5 {
                darkGrayDigits()
                recallBalance = false
                decimalButton.isHighlighted = false
                decimalButton.highlightColor = .lightGray
                
                return
            }
            else {
                decimalButton.highlightColor = .lightGray
                decimalButton.isHighlighted = false
                decimalInput()
            }
            
        default:
            break
        }
        
    }
    
    @objc private func zeroButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - zeroButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            zeroButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            
            zeroButton.highlightColor = .lightGray
            zeroButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > 0.5 {
                zeroButton.highlightColor = lightRed
                zeroButton.isHighlighted = true
                orangeDigits()
                storeBalance = true
                
                } else {
                    zeroButton.highlightColor = .lightGray
                    zeroButton.isHighlighted = true
            }
            
        case .ended:
            
            if longPressEndTime > 0.5 {
                    darkGrayDigits()
                    storeBalance = false
                    zeroButton.isHighlighted = false
                    zeroButton.highlightColor = .lightGray

                    return
                }
                else {
                
                    zeroButton.highlightColor = .lightGray
                    zeroButton.isHighlighted = false
                    numberInput(zeroButton)
                }
            
        default:
            break
        }
        
    }

    @objc private func oneButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: oneButton, gesture: gesture)
    }
    
    @objc private func twoButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: twoButton, gesture: gesture)
    }
    
    @objc private func threeButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: threeButton, gesture: gesture)
    }
    
    @objc private func fourButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: fourButton, gesture: gesture)
    }
    
    @objc private func fiveButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: fiveButton, gesture: gesture)
    }
    
    @objc private func sixButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: sixButton, gesture: gesture)
    }
    
    @objc private func sevenButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: sevenButton, gesture: gesture)
    }
    
    @objc private func eightButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: eightButton, gesture: gesture)
    }
    
    @objc private func nineButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: nineButton, gesture: gesture)
    }
    
    private func decimalInput(){
        // No override of isNewNumberEntry because action depends on state of xRegister
        
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        if xRegisterDecimals == 0 {
            UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
        } else if xRegisterDecimals == 1 {
            UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
        }
    }
    
 
    
    
    
    
    //MARK: Stack manipulation
    
    func clearStack(){
        var stackRegisters = [Double]()
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        defaults.set(self.stackRegisters, forKey: "stackRegisters")
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set(0.0, forKey: "lRegisterY")
        defaults.set(0.0, forKey: "lOperator")
        updateDisplays()
        print("test")
    }
    
    @objc private func enterInput(){
        isNewNumberEntry = true // Adding digits after enter key should be creating a new number
        stackAutoLift = false
        liftStackRegisters()
        clearLastXRegister()
        updateDisplays()
    }
    

    
    @objc private func deleteInput(){
        isNewNumberEntry = false //Adding digits after delete key should be editing same number
        stackAutoLift = false
        
        // Note that xRegisterDecimals = 0 or 1 for zero decimals (0 means decimal modification not invoked
        // while 1 is decimal modification invoked) and 2 for 1 decimal, 3 for 2 decimals and so on
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        if xRegisterDecimals <= 1 {
            
            let xRegisterNew = Double(floor(stackRegisters[0]/10))
            amendStackRegister(value: xRegisterNew, at: 0)
            
        } else if xRegisterDecimals > 1 {
            let intermediateX = floor(stackRegisters[0] * pow(10.0, Double(xRegisterDecimals - 2)))
            
            let xRegisterNew = Double(intermediateX / pow(10.0, Double(xRegisterDecimals - 2)))
            amendStackRegister(value: xRegisterNew, at: 0)
            
            UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
        }
        
        if xRegisterDecimals <= 2 {
            UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
        }
        clearLastXRegister()
        updateDisplays()
    }
    
    @objc private func clearInput(){
        stackAutoLift = false
        isNewNumberEntry = true // Start new number after clear input
        
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if stackRegisters[0] == 0.0 {
            if stackRegisters[1] == 0.0 {
                if stackRegisters[2] == 0.0 {
                    if stackRegisters[3] == 0.0 {
                        defaults.set(stackRegisters, forKey: "stackRegisters")
                        dropStackRegistersOneAtATime()
                        clearLastRegisters()
                        updateDisplays()
                        return
                    } else {
                        stackRegisters[3] = 0.0
                    }
                } else {
                    stackRegisters[2] = 0.0
                }
            } else {
                stackRegisters[1] = 0.0
            }
        } else {
            stackRegisters[0] = 0.0
        }
        
        clearLastRegisters()
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @ objc private func clearButtonLongAction(gesture: UILongPressGestureRecognizer){
        stackAutoLift = false
        
        isNewNumberEntry = true // Start new number after clear input
        
        let zeroRegisters = [0.0, 0.0, 0.0, 0.0, 0.0]
        defaults.set(zeroRegisters, forKey: "stackRegisters")
        clearLastRegisters()
        updateDisplays()
    }
    
    private func clearLastRegisters(){
        defaults.set(0.0, forKey: "lRegisterY")
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")
    }
    
    private func clearLastXRegister(){
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")
    }
    
    private func numberInput(_ sender: CalculatorButton){
        
        var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if storeBalance {
            if sender.digitValue != 0 {
                defaults.set(stackRegistersOld[0], forKey: sender.digitString!)
            }
            isNewNumberEntry = false
            return
        }
        
        if recallBalance {
            if sender.digitValue != 0 {
                let xRegisterNew = defaults.double(forKey: sender.digitString!)
                amendStackRegister(value: xRegisterNew, at: 0)
                updateNumberDisplay()
            }
            isNewNumberEntry = false
            return
        }

        
        if stackAutoLift {
            liftStackRegisters()
            stackAutoLift = false
            clearLastRegisters()
            updateLastDisplay()
        }
        
        if isNewNumberEntry {
            amendStackRegister(value: 0.0, at: 0)
            isNewNumberEntry = false
            UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
        }
        
        var xRegisterNew: Double?
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        let xRegisterOld = stackRegistersOld[0]
        
        if  xRegisterDecimals == 0 {
            xRegisterNew = xRegisterOld * 10.0 + sender.digitValue!
        } else if xRegisterDecimals > 0 {
            xRegisterNew = xRegisterOld + pow(10.0, -1.0 * Double(xRegisterDecimals)) * sender.digitValue!
            UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
        } else {
            xRegisterNew = xRegisterOld
        }
        
        amendStackRegister(value: xRegisterNew!, at: 0)
        defaults.set(xRegisterNew!, forKey: "lRegisterX")
        updateNumberDisplay()
    }
    
    private func amendStackRegister(value: Double, at: Int){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[at] = value
        defaults.set(stackRegisters, forKey: "stackRegisters")
    }
    
    private func liftStackRegisters(){ // Keep X and copy rest up
        let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        var stackRegistersNew = [Double]()
        stackRegistersNew.append(stackRegistersOld[0])
        stackRegistersNew.append(contentsOf: stackRegistersOld) // Lift rest of stack registry up
        defaults.set(stackRegistersNew, forKey: "stackRegisters")
        defaults.set(stackRegistersNew[1], forKey: "lRegisterY")
        defaults.set("", forKey: "lOperator")
        
    }
    
    private func dropStackRegistersOneAtATime(){
        var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegistersOld.removeFirst()
        var stackRegistersNew = [Double]()
        stackRegistersNew.append(contentsOf: stackRegistersOld)
        
        // Prevents reducing function below minimum 5 elements required at all times
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        
        defaults.set(stackRegistersNew, forKey: "stackRegisters")
        
    }
    
    private func dropStackRegisters(){
        var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegistersOld.removeFirst()
        stackRegistersOld.removeFirst()
        var stackRegistersNew = [Double]()
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(contentsOf: stackRegistersOld)
       
        // Prevents reducing function below minimum 5 elements required at all times
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        stackRegistersNew.append(0.0)
        
        defaults.set(stackRegistersNew, forKey: "stackRegisters")

    }
    
    //MARK: Operations
    
    private func processInput(_ operation: String){
        
        // Process operator input
            
            isNewNumberEntry = true
            stackAutoLift = true
            var unaryAction = false
            
            // Get xRegister value
            let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
            
            let xRegister = stackRegisters[0]
            let yRegister = stackRegisters[1]
            
            defaults.set(xRegister, forKey: "lRegisterX")

            
            var xRegisterNew: Double
            
            switch operation {
                
            case "EE":
                xRegisterNew = yRegister * pow(10.0, Double(xRegister))
            case "√":
                xRegisterNew = pow(yRegister, 1.0 / xRegister)
            case "1/x":
                xRegisterNew = 1 / xRegister
                unaryAction = true
            case "%":
                xRegisterNew = yRegister * xRegister / 100
            case "% Δ":
                xRegisterNew = (xRegister - yRegister) / yRegister
            case "% T":
                xRegisterNew = xRegister / (yRegister + xRegister)
            case "e^x":
                xRegisterNew = exp(xRegister)
                unaryAction = true
            case "ln x":
                xRegisterNew = log(xRegister)
                unaryAction = true
            case "y^x":
                xRegisterNew = pow(yRegister, xRegister)
            case "pi" :
                xRegisterNew = Double.pi
                unaryAction = true
            case "sin":
                xRegisterNew = sin(xRegister)
                unaryAction = true
            case "cos":
                xRegisterNew = cos(xRegister)
                unaryAction = true
            case "tan":
                xRegisterNew = tan(xRegister)
                unaryAction = true
            case "asin":
                xRegisterNew = asin(xRegister)
                unaryAction = true
            case "acos":
                xRegisterNew = acos(xRegister)
                unaryAction = true
            case "atan":
                xRegisterNew = atan(xRegister)
                unaryAction = true

            default:
                updateNumberDisplay()
                return
            }
        
        defaults.set(operation, forKey: "lOperator")
        
        if unaryAction {
            defaults.set(0.0, forKey: "lRegisterY")
            defaults.set(xRegister, forKey: "lRegisterX")
        } else {
            defaults.set(operation, forKey: "lOperator")
            defaults.set(xRegister, forKey: "lRegisterX")
            dropStackRegisters()
        }
        
            amendStackRegister(value: xRegisterNew, at: 0)
        
            updateDisplays()
        
    }
    
    private func basicOperator(_ operatorAction: String){
        
        isNewNumberEntry = true
        stackAutoLift = true
        
        // Get xRegister value
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        let yRegister = stackRegisters[1]
        
        defaults.set(yRegister, forKey: "lRegisterY")
        defaults.set(xRegister, forKey: "lRegisterX")
        defaults.set(operatorAction, forKey: "lOperator")
        
        var xRegisterNew: Double
        
        switch operatorAction {
            
        case "+":
            xRegisterNew = yRegister + xRegister
        case "−":
            xRegisterNew = yRegister - xRegister
        case "x":
            xRegisterNew = yRegister * xRegister
        case "÷":
            xRegisterNew = yRegister / xRegister
        case "chs":
            xRegisterNew = -1 * xRegister
            stackAutoLift = false // CHS is not an operation that should trigger stackautolift
        default:
            xRegisterNew = xRegister
        }
        
        dropStackRegisters()

        amendStackRegister(value: xRegisterNew, at: 0)

        updateDisplays()
        
    }
    
    //MARK: Update displays
    
    private func updateFunctionDisplay(button: CalculatorButton, stateIndex: Int){
        functionDisplay.text = button.states![stateIndex]
    }
    
    private func updateFunctionDisplay2(button: CalculatorButton, stateIndex: Int){
        mainDisplay.text = button.states![stateIndex]
    }
    
    private func resetFunctionDisplay(){
        functionDisplay.text = ""
    }
    
    private func updateNumberDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        
        let xRegisterNS = NSNumber(value: xRegister)
        
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        if xRegisterDecimals == 1 {
            formatterXRegister.minimumFractionDigits = xRegisterDecimals
        } else {
            formatterXRegister.minimumFractionDigits = xRegisterDecimals - 1
        }
        var xRegisterString = formatterXRegister.string(from: xRegisterNS) ?? ""
        if xRegister == 0.0 {
            xRegisterString = ""
        }
        mainDisplay.text = xRegisterString
    }
    
    private func updateStackDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]

        let zRegister = stackRegisters[2]
        let tRegister = stackRegisters[3]
        let uRegister = stackRegisters[4]
        
        let zRegisterNS = NSNumber(value: zRegister)
        let tRegisterNS = NSNumber(value: tRegister)
        let uRegisterNS = NSNumber(value: uRegister)
        
        var zRegisterString, tRegisterString, uRegisterString : String
        
        if(abs(zRegister) > stackRegisterDisplaySize) {
            zRegisterString = self.formatterScientific.string(from: zRegisterNS) ?? ""
        } else {
            zRegisterString = self.formatterDecimal.string(from: zRegisterNS) ?? ""
        }
        
        if(abs(tRegister) > stackRegisterDisplaySize) {
            tRegisterString = self.formatterScientific.string(from: tRegisterNS) ?? ""
        } else {
            tRegisterString = self.formatterDecimal.string(from: tRegisterNS) ?? ""
        }
        
        if(abs(uRegister) > stackRegisterDisplaySize) {
            uRegisterString = self.formatterScientific.string(from: uRegisterNS) ?? ""
        } else {
            uRegisterString = self.formatterDecimal.string(from: uRegisterNS) ?? ""
        }
        
        tzRegisterDisplay.text = uRegisterString + "\n" + "\n" + tRegisterString + "\n" + "\n" + zRegisterString
        
    }
    
    private func updateLastDisplay(){
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        // Get l registers (these need to be set by other operations)
        let lRegisterX = defaults.double(forKey: "lRegisterX")
        let lRegisterY = defaults.double(forKey: "lRegisterY")
        
        let lRegisterXNS = NSNumber(value: lRegisterX)
        let lRegisterYNS = NSNumber(value: lRegisterY)
        
        var lRegisterYString, lRegisterXString : String
        
        formatterLYRegister.minimumFractionDigits = UserDefaults.standard.integer(forKey: "numDecimals")
        formatterLXRegister.minimumFractionDigits = UserDefaults.standard.integer(forKey: "numDecimals")
        
        let yRegister = stackRegisters[1]

        lRegisterYString = formatterLYRegister.string(from: lRegisterYNS) ?? ""
        lRegisterXString = formatterLXRegister.string(from: lRegisterXNS) ?? ""
        let yRegisterString = formatterLYRegister.string(from: NSNumber(value: yRegister)) ?? ""

        if yRegisterString == "" {
            yRegisterDisplay.text = ""
        } else {
            yRegisterDisplay.text = yRegisterString
        }

        var lOperatorString = defaults.string(forKey: "lOperator") ?? ""
        
        if lOperatorString != "" {
            lOperatorString = " " + lOperatorString + " "
        }
        
        if lRegisterX == 0.0 {
            lRegisterXString = ""
        } else {
            if lOperatorString != "" {
                lRegisterXString += "  ="
            }
        }
 
        if (stackRegisters[1] == 0.0 || stackRegisters[1] != lRegisterY) && lOperatorString != "" {
            if lRegisterY == 0.0 {
                if (lOperatorString == " e^x " || lOperatorString == " ln x " || lOperatorString == " 1/x ") {
                    if lRegisterX == 0.0 {
                        lRegisterYString = ""
                    } else {
                        lRegisterYString = "0  +"
                    }
                } else {
                    lRegisterYString = "0"
                }
            }

            lRegisterDisplay.text = lRegisterYString + "  " + lOperatorString + "  " + lRegisterXString + "  "
        } else {
            
            if lRegisterY == 0.0 {
                lRegisterYString = ""
            }

            if lOperatorString != "" {
                lRegisterDisplay.text = "" + lOperatorString + "  " + lRegisterXString + "  "
            } else {
                lRegisterDisplay.text = "" + lRegisterXString + "  "
            }


        }
        
    }
    
    private func updateDisplays(){
        
        resetFunctionDisplay()
        updateNumberDisplay()
        updateLastDisplay()
        updateStackDisplay()

        
    }
    
    private func printStackRegister(){
        
        let stackRegister = defaults.array(forKey: "stackRegisters") as! [Double]
        
        print(stackRegister[0])
        print(stackRegister[1])
        print(stackRegister[2])
        print(stackRegister[3])
    }
    
    private func orangeDigits(){
        oneButton.backgroundColor = lighterOrange
        twoButton.backgroundColor = lighterOrange
        threeButton.backgroundColor = lighterOrange
        fourButton.backgroundColor = lighterOrange
        fiveButton.backgroundColor = lighterOrange
        sixButton.backgroundColor = lighterOrange
        sevenButton.backgroundColor = lighterOrange
        eightButton.backgroundColor = lighterOrange
        nineButton.backgroundColor = lighterOrange
        
        oneButton.highlightColor = .black
        twoButton.highlightColor = .black
        threeButton.highlightColor = .black
        fourButton.highlightColor = .black
        fiveButton.highlightColor = .black
        sixButton.highlightColor = .black
        sevenButton.highlightColor = .black
        eightButton.highlightColor = .black
        nineButton.highlightColor = .black
    }
    
    private func darkGrayDigits(){
        oneButton.backgroundColor = .darkGray
        twoButton.backgroundColor = .darkGray
        threeButton.backgroundColor = .darkGray
        fourButton.backgroundColor = .darkGray
        fiveButton.backgroundColor = .darkGray
        sixButton.backgroundColor = .darkGray
        sevenButton.backgroundColor = .darkGray
        eightButton.backgroundColor = .darkGray
        nineButton.backgroundColor = .darkGray
        
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
    
    //MARK: RPN Logic
    
    
}

//MARK: To-do

/*
 
 Fix action for touchUpInside - cancel when drag away from the button
 Add delete button:
 
 */


