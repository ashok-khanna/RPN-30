//
//  Gestures.swift
//  RPN-30
//
//  Created by Ashok Khanna on 1/2/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

extension Calculator {
    
    @objc func zeroButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - zeroButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            zeroButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            
            zeroButton.highlightColor = .lightGray
            zeroButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                zeroButton.highlightColor = longHighlightColor
                zeroButton.isHighlighted = true
                storeBalance = true
                changeFunctionLabelToOrange("zero")
                
            } else {
                zeroButton.highlightColor = .lightGray
                zeroButton.isHighlighted = true
            }
            
        case .ended:
            changeFunctionLabelToLightGray("zero")
            if longPressEndTime > longPressRequiredTime {
                storeBalance = false
                zeroButton.isHighlighted = false
                zeroButton.highlightColor = .lightGray

                return
            }
            else {
                zeroButton.isHighlighted = false
                processDigit(zeroButton)
                clearLastRegisters()
                updateXRegisterDisplay(resultMode: false)
            }
            
        default:
            break
        }
        
    }
    
    @objc func decimalButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - decimalButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            decimalButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            decimalButton.highlightColor = .lightGray
            decimalButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                decimalButton.highlightColor = longHighlightColor
                decimalButton.isHighlighted = true
                recallBalance = true
                changeFunctionLabelToOrange("decimal")
            } else {
                decimalButton.isHighlighted = true
            }
            
        case .ended:
            changeFunctionLabelToLightGray("decimal")
            if longPressEndTime > longPressRequiredTime {
                recallBalance = false
                decimalButton.isHighlighted = false
                decimalButton.highlightColor = .lightGray

                return
            }
            else {
                decimalButton.isHighlighted = false
                decimalInput()
            }
            
        default:
            break
        }
        
    }
    
    
    @objc func clearButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - clearButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            clearButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            clearButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                clearButton.highlightColor = longHighlightColor
                clearButton.isHighlighted = true
                
                
            } else {
                clearButton.isHighlighted = true
            }
            
        case .ended:
            
            stackAutoLift = false
            isNewNumberEntry = true // Start new number after clear input
            
            if longPressEndTime > longPressRequiredTime {
                
                clearButton.isHighlighted = false
                clearButton.highlightColor = .lightGray
                
                clearStack()
                clearLastRegisters()
                updateDisplays(afterOperation: false, onClear: true)
  
                return
            }
            else {
                clearButton.isHighlighted = false
            
                var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
                
                if stackRegisters[0] == 0.0 {
                    if stackRegisters[1] == 0.0 {
                        if stackRegisters[2] == 0.0 {
                            if stackRegisters[3] == 0.0 {
                                defaults.set(stackRegisters, forKey: "stackRegisters")
                                dropStackRegistersOneAtATime()
                                
                            } else {
                                stackRegisters[3] = 0.0
                                defaults.set(stackRegisters, forKey: "stackRegisters")
                                dropStackRegistersOneAtATime()
                            }
                        } else {
                            stackRegisters[2] = 0.0
                            defaults.set(stackRegisters, forKey: "stackRegisters")
                            dropStackRegistersOneAtATime()
                        }
                    } else {
                        stackRegisters[1] = 0.0
                        defaults.set(stackRegisters, forKey: "stackRegisters")
                        dropStackRegistersOneAtATime()
                        
                    }
                } else {
                    stackRegisters[0] = 0.0
                    defaults.set(stackRegisters, forKey: "stackRegisters")
                }
                
                clearLastRegisters()
                updateDisplays(afterOperation: false, onClear: true)
            }
            
        default:
            break
        }
        
    }
    
    func completeOperation(button: CalculatorButton, gesture: UILongPressGestureRecognizer) {
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - button.longPressStartTime
        let buttonOperation = button.operationString ?? ""
        
        switch gesture.state {
            
        case .began:
            button.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            
            button.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                button.highlightColor = longHighlightColor
                button.isHighlighted = true
                changeFunctionLabelToOrange(button.digitString!)
                
                if !(storeBalance || recallBalance){
                    
                    updateXRegisterDisplayForFunction(buttonOperation)
                    
                } else {

                    button.isHighlighted = true
                }
            }
            
            
        case .ended:
            updateLastDisplayToNil()
            changeFunctionLabelToLightGray(button.digitString!)
            if longPressEndTime > longPressRequiredTime {

                if !(storeBalance || recallBalance){
                    
                    button.isHighlighted = false
                    button.highlightColor = .lightGray
                    processOperation(buttonOperation)
                    updateDisplays(afterOperation: true)
                    
                    return
                } else {
                    button.isHighlighted = false
                    button.highlightColor = .lightGray
                    processStoreRecall(button)
                    // Changed the following from false to true to make decimals appear in recalled values May 10, 2020
                    updateXRegisterDisplay(resultMode: true)
                }
            } else {
                button.isHighlighted = false
                
                if !(storeBalance || recallBalance){
                    processDigit(button)
                    updateXRegisterDisplay(resultMode: false)
                } else {
                    processStoreRecall(button)
                    clearLastRegisters()
                    // Changed the following from false to true to make decimals appear in recalled values May 10, 2020
                    updateXRegisterDisplay(resultMode: true)
                }
                
            }
            
        default:
            break
        }
    }
    
    @objc func oneButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: oneButton, gesture: gesture)
    }
    
    @objc func twoButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: twoButton, gesture: gesture)
    }
    
    @objc func threeButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: threeButton, gesture: gesture)
    }
    
    @objc func fourButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: fourButton, gesture: gesture)
    }
    
    @objc func fiveButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: fiveButton, gesture: gesture)
    }
    
    @objc func sixButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: sixButton, gesture: gesture)
    }
    
    @objc func sevenButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: sevenButton, gesture: gesture)
    }
    
    @objc func eightButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: eightButton, gesture: gesture)
    }
    
    @objc func nineButtonLongAction(gesture: UILongPressGestureRecognizer){
        completeOperation(button: nineButton, gesture: gesture)
    }
    
    @objc func enterInput(){
        isNewNumberEntry = true // Adding digits after enter key should be creating a new number
        stackAutoLift = false
        liftStackRegisters()
        clearLastRegisters()
        updateDisplays(afterOperation: false)
    }
    
    @objc func plusInput(){
        processOperation("+")
        updateDisplays(afterOperation: true)
        
    }
    
    @objc func minusInput(){
        processOperation("−")
        updateDisplays(afterOperation: true)
        
    }
    
    @objc func multiplyInput(){
        processOperation("x")
        updateDisplays(afterOperation: true)
        
    }
    
    @objc func divideInput(){
        processOperation("÷")
        updateDisplays(afterOperation: true)
    }
    
    @objc func chsInput(){
        processOperation("chs")
        updateXRegisterDisplay(resultMode: false)
    }
    
    @objc func deleteInput(){
        isNewNumberEntry = false //Adding digits after delete key should be editing same number
        stackAutoLift = false
        
        // Note that xRegisterDecimals = 0 or 1 for zero decimals (0 means decimal modification not invoked
        // while 1 is decimal modification invoked) and 2 for 1 decimal, 3 for 2 decimals and so on
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        var xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        // Code for getting decimals if number is from result (since then it will have xRegisterDecimals = 0
        
        if xRegisterDecimals == 0 {
            xRegisterDecimals = 1
            for i in 0...4 {

                let truncateDecimals = (stackRegisters[0] * pow(10.0, Double(i))).truncatingRemainder(dividingBy: 1.0)

                if truncateDecimals == 0 {
                    break
                } else {
                    xRegisterDecimals += 1
                }
            }
            
        }
        
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
        
        clearLastRegisters()
        updateLastDisplayToNil()
        updateXRegisterDisplay(resultMode: false)
    }
    
    @objc  func registerInputOne(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[2]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateXRegisterDisplay(resultMode: false)
    }
    
    @objc  func registerInputTwo(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[3]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        clearLastRegisters()
        updateXRegisterDisplay(resultMode: false)
    }
    
    @objc  func registerInputThree(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[4]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        clearLastRegisters()
        updateXRegisterDisplay(resultMode: false)
    }
    
    @objc  func cancelInput(){
        
        if lRegisterDisplay.text != "" {
            var stackRegisters = [Double]()
            var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
            
            if defaults.bool(forKey: "lUnaryAction") {
                stackRegisters.append(defaults.double(forKey: "lRegisterX"))
                stackRegistersOld.removeFirst()
                stackRegisters.append(contentsOf: stackRegistersOld)
            } else {
                stackRegisters.append(defaults.double(forKey: "lRegisterX"))
                stackRegisters.append(defaults.double(forKey: "lRegisterY"))
                
                stackRegistersOld.removeFirst()
                stackRegisters.append(contentsOf: stackRegistersOld)
            }
            
            defaults.set(stackRegisters, forKey: "stackRegisters")
            stackAutoLift = false
            
            clearLastRegisters()
            updateDisplays(afterOperation: false)
        }
 
    }
    
    @objc  func swapInput(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        let yRegister = stackRegisters[1]
        
        stackRegisters[0] = yRegister
        stackRegisters[1] = xRegister
        
        defaults.set(stackRegisters, forKey: "stackRegisters")
        
        clearLastRegisters()
        updateDisplays(afterOperation: false)
    }
    
     func addTargets(){
        
        let zeroLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(zeroButtonLongAction(gesture:)))
        zeroLongTapGesture.minimumPressDuration = minimumPressDuration
        zeroButton.addGestureRecognizer(zeroLongTapGesture)
        
        let decimalLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(decimalButtonLongAction(gesture:)))
        decimalLongTapGesture.minimumPressDuration = minimumPressDuration
        decimalButton.addGestureRecognizer(decimalLongTapGesture)
        
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
        
        let clearLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(clearButtonLongAction(gesture:)))
        clearLongTapGesture.minimumPressDuration = minimumPressDuration
        clearButton.addGestureRecognizer(clearLongTapGesture)
        
        let swapShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(swapInput))
        swapShortTapGesture.numberOfTapsRequired = 1
        yRegisterDisplay.addGestureRecognizer(swapShortTapGesture)
        
        let cancelOperationShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelInput))
        cancelOperationShortTapGesture.numberOfTapsRequired = 1
        lRegisterDisplay.addGestureRecognizer(cancelOperationShortTapGesture)
        
        let xRegisterDisplayShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteInput))
        xRegisterDisplayShortTapGesture.numberOfTapsRequired = 1
        xRegisterDisplay.addGestureRecognizer(xRegisterDisplayShortTapGesture)
        
        let registerTapGestureOne = UITapGestureRecognizer(target: self, action: #selector(registerInputOne))
        
        let registerTapGestureTwo = UITapGestureRecognizer(target: self, action: #selector(registerInputTwo))
        
        let registerTapGestureThree = UITapGestureRecognizer(target: self, action: #selector(registerInputThree))
        
        registerTapGestureOne.numberOfTapsRequired = 1
        registerTapGestureTwo.numberOfTapsRequired = 2
        registerTapGestureThree.numberOfTapsRequired = 3
        
        registerTapGestureOne.require(toFail: registerTapGestureTwo)
        registerTapGestureTwo.require(toFail: registerTapGestureThree)
        
        sRegisterDisplay.addGestureRecognizer(registerTapGestureOne)
        sRegisterDisplay.addGestureRecognizer(registerTapGestureTwo)
        sRegisterDisplay.addGestureRecognizer(registerTapGestureThree)
        
        
    }
    
}
