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

    let sRegisterDisplay = UILabel()
    let yRegisterDisplay = UILabel()
    let lRegisterDisplay = UILabel()
    let mainDisplay = UILabel()
    
    let lightOrange = UIColor.orange.lighter(by: 25.0)
    let lighterOrange = UIColor.orange.lighter(by: 50.0)
    let lightRed = UIColor.red.lighter(by: 25.0)
    
    //Bounds
    
    let numberOfButtonRows = 7.0
    let numberOfButtonCols = 4.0
    let spacingBetweenButtonsAsPercentageOfButton = 0.2
    
    lazy var rowWidth = numberOfButtonCols + (numberOfButtonCols - 1.0) * spacingBetweenButtonsAsPercentageOfButton
    lazy var colHeight = numberOfButtonRows + (numberOfButtonRows - 1.0) * spacingBetweenButtonsAsPercentageOfButton
    lazy var buttonWidth = CGFloat(1.0 / rowWidth)
    lazy var buttonHeight = CGFloat(1.0 / colHeight)
    
    lazy var registerHeight = CGFloat(1.0 / (colHeight * 3.0)) // Zero padding between registers as we will use center alignment vs. calculating appropriate padding
    
    lazy var mainDisplayWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    
    lazy var zeroButtonWidth = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    lazy var enterButtonHeight = CGFloat((2 + spacingBetweenButtonsAsPercentageOfButton) / colHeight)
    lazy var lRegisterWidth = CGFloat((3 + 2 * spacingBetweenButtonsAsPercentageOfButton) / rowWidth)
    
    var actualButtonHeight, actualButtonWidth, buttonHorizontalPadding, buttonVerticalPadding: CGFloat?
    
    // Set spaces between buttons
    // What is CGFloat and how can I use it in constants (see bit later) but also use double there?
    

    
    // Number formatters
    let formatterDecimal = NumberFormatter()
    let formatterScientific = NumberFormatter() // For displaying numbers in scientific mode
    let formatterXRegister = NumberFormatter() // For showing all decimals for x Registe
    
    let maxNumberLengthForLRegister = 999999999.9
    let maxNumberLengthForSRegister = 99999999.9
    let defaultMaximumDecimalsForXRegister = 5
    
    let functionLabelSize = UIFont.systemFont(ofSize: 8.5)
    
    let stackRegisterDisplaySize = 999999.9
    
    // Set color for function titles

    
    let defaults = UserDefaults.standard
    var stackRegisters: [Double]
    
    override init(frame: CGRect) { // Used when programatically instantiate view
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
        
        actualButtonHeight = self.bounds.height * buttonHeight
        actualButtonWidth = self.bounds.width * buttonWidth
        
        buttonHorizontalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / rowWidth) * self.bounds.width
        
        buttonVerticalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / colHeight) * self.bounds.height
        
        setupNSFormatters()
        setupCalculator()
    }
    
    required init?(coder aDecoder: NSCoder) { // Used when instantiating via storyboard
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

        actualButtonHeight = self.bounds.height * buttonHeight
        actualButtonWidth = self.bounds.width * buttonWidth
        
        buttonHorizontalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / rowWidth) * self.bounds.width
        
        buttonVerticalPadding = CGFloat(spacingBetweenButtonsAsPercentageOfButton / colHeight) * self.bounds.height
        
        setupNSFormatters()
        formatterXRegister.numberStyle = .decimal

        setupCalculator()
    }
    
    //MARK:  Methods
    
     func setupCalculator(){
        
        initButtons()

        setLayout()
        
        formatCalculator()
        
        self.layoutIfNeeded()

        updateDisplays()
        
        addTargets()
  
    }
    
    
    //MARK: Long press functions
    
     func calculateButtonStage(timeInterval: TimeInterval, numberOfStages: Int) -> Int {
        
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

     func completeOperation(button: CalculatorButton, gesture: UILongPressGestureRecognizer) {
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - button.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            button.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            
            button.highlightColor = .lightGray
            button.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                button.highlightColor = lightOrange
                button.isHighlighted = true
                
                if !(storeBalance || recallBalance){
                    let stateIndex = calculateButtonStage(timeInterval: longPressEndTime, numberOfStages: button.states!.count)
                    updateFunctionDisplay(button: button, stateIndex: stateIndex)
                    
                } else {
                    button.highlightColor = .lightGray
                    button.isHighlighted = true
                }
            }
            
            
        case .ended:
            
            if longPressEndTime > longPressRequiredTime {
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
    
    //MARK: Calculation Methods
    
     func processInput(_ operation: String){
        
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
            updateNumberDisplay(true)
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
    
     func basicOperator(_ operatorAction: String){
        
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
    
     func numberInput(_ sender: CalculatorButton){
        
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
                updateNumberDisplay(true)
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
    
     func decimalInput(){
        // No override of isNewNumberEntry because action depends on state of xRegister
        
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        if xRegisterDecimals == 0 {
            UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
        } else if xRegisterDecimals == 1 {
            UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
        }
    }
    
    //MARK: Stack Manipulation Methods
    
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
    
     func clearLastRegisters(){
        defaults.set(0.0, forKey: "lRegisterY")
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")
    }
    
     func clearLastXRegister(){
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")
    }
    
    
    
     func amendStackRegister(value: Double, at: Int){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[at] = value
        defaults.set(stackRegisters, forKey: "stackRegisters")
    }
    
     func liftStackRegisters(){ // Keep X and copy rest up
        let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        var stackRegistersNew = [Double]()
        stackRegistersNew.append(stackRegistersOld[0])
        stackRegistersNew.append(contentsOf: stackRegistersOld) // Lift rest of stack registry up
        defaults.set(stackRegistersNew, forKey: "stackRegisters")
        defaults.set(stackRegistersNew[1], forKey: "lRegisterY")
        defaults.set("", forKey: "lOperator")
        
    }
    
     func dropStackRegistersOneAtATime(){
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
    
     func dropStackRegisters(){
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
    
    //MARK: Output Display Methods
    
     func updateFunctionDisplay(button: CalculatorButton, stateIndex: Int){
        
        mainDisplay.text = button.states![stateIndex]
        
    }
    
     func updateDisplays(){
        
        updateNumberDisplay(true)
        updateLastDisplay()
        updateStackDisplay()
        
    }
    
     func updateNumberDisplay(_ resultMode: Bool = false){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        
        let xRegisterNS = NSNumber(value: xRegister)
        var xRegisterString: String
        
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        if resultMode {
            xRegisterString = formatterDecimal.string(from: xRegisterNS) ?? ""
            
        } else {
            if xRegisterDecimals == 1 {
                formatterXRegister.minimumFractionDigits = xRegisterDecimals
            } else {
                formatterXRegister.minimumFractionDigits = xRegisterDecimals - 1
            }
            xRegisterString = formatterXRegister.string(from: xRegisterNS) ?? ""
        }
        
        mainDisplay.text = xRegisterString
    }

    
     func updateLastDisplay(){
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        // Get l registers (these need to be set by other operations)
        let lRegisterX = defaults.double(forKey: "lRegisterX")
        let lRegisterY = defaults.double(forKey: "lRegisterY")
        
        let lRegisterXNS = NSNumber(value: lRegisterX)
        let lRegisterYNS = NSNumber(value: lRegisterY)
        
        var lRegisterYString, lRegisterXString : String
        
        let yRegister = stackRegisters[1]
        
        let yRegisterString = formatterDecimal.string(from: NSNumber(value: yRegister)) ?? ""
        
        if yRegisterString == "" {
            yRegisterDisplay.text = ""
        } else {
            yRegisterDisplay.text = yRegisterString
        }
        
        
        if abs(lRegisterY) > maxNumberLengthForLRegister {
            lRegisterYString = formatterScientific.string(from: lRegisterYNS) ?? ""
        } else {
            lRegisterYString = formatterDecimal.string(from: lRegisterYNS) ?? ""
        }
        
        if abs(lRegisterX) > maxNumberLengthForLRegister {
            lRegisterXString = formatterScientific.string(from: lRegisterXNS) ?? ""
        } else {
            lRegisterXString = formatterDecimal.string(from: lRegisterXNS) ?? ""
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
    
     func updateStackDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let zRegister = stackRegisters[2]
        let tRegister = stackRegisters[3]
        let uRegister = stackRegisters[4]
        
        let zRegisterNS = NSNumber(value: zRegister)
        let tRegisterNS = NSNumber(value: tRegister)
        let uRegisterNS = NSNumber(value: uRegister)
        
        var zRegisterString, tRegisterString, uRegisterString : String
        
        if(abs(zRegister) > maxNumberLengthForSRegister) {
            zRegisterString = self.formatterScientific.string(from: zRegisterNS) ?? ""
        } else {
            zRegisterString = self.formatterDecimal.string(from: zRegisterNS) ?? ""
        }
        
        if(abs(tRegister) > maxNumberLengthForSRegister) {
            tRegisterString = self.formatterScientific.string(from: tRegisterNS) ?? ""
        } else {
            tRegisterString = self.formatterDecimal.string(from: tRegisterNS) ?? ""
        }
        
        if(abs(uRegister) > maxNumberLengthForSRegister) {
            uRegisterString = self.formatterScientific.string(from: uRegisterNS) ?? ""
        } else {
            uRegisterString = self.formatterDecimal.string(from: uRegisterNS) ?? ""
        }
        
        sRegisterDisplay.text = uRegisterString + "\n" + "\n" + tRegisterString + "\n" + "\n" + zRegisterString
        
    }
    

    
}

