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
                zeroButton.highlightColor = lightRed
                zeroButton.isHighlighted = true
                storeBalance = true
                
            } else {
                zeroButton.highlightColor = .lightGray
                zeroButton.isHighlighted = true
            }
            
        case .ended:
            
            if longPressEndTime > longPressRequiredTime {
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
    
    @objc func decimalButtonLongAction(gesture: UILongPressGestureRecognizer){
        
        let longPressEndTime = NSDate.timeIntervalSinceReferenceDate - decimalButton.longPressStartTime
        
        switch gesture.state {
            
        case .began:
            decimalButton.longPressStartTime = NSDate.timeIntervalSinceReferenceDate
            decimalButton.highlightColor = .lightGray
            decimalButton.isHighlighted = true
            
        case .changed:
            if longPressEndTime > longPressRequiredTime {
                decimalButton.highlightColor = lightRed
                decimalButton.isHighlighted = true
                recallBalance = true
                
            } else {
                decimalButton.highlightColor = .lightGray
                decimalButton.isHighlighted = true
            }
            
        case .ended:
            
            if longPressEndTime > longPressRequiredTime {
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
        clearLastXRegister()
        updateDisplays()
    }
    
    @objc func plusInput(){
        basicOperator("+")
    }
    
    @objc func minusInput(){
        basicOperator("−")
    }
    
    @objc func multiplyInput(){
        basicOperator("x")
    }
    
    @objc func divideInput(){
        basicOperator("÷")
    }
    
    @objc func chsInput(){
        basicOperator("chs")
    }
    
    @objc func clearInput(){
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
    
    @ objc func clearButtonLongAction(gesture: UILongPressGestureRecognizer){
        stackAutoLift = false
        
        isNewNumberEntry = true // Start new number after clear input
        
        let zeroRegisters = [0.0, 0.0, 0.0, 0.0, 0.0]
        defaults.set(zeroRegisters, forKey: "stackRegisters")
        clearLastRegisters()
        updateDisplays()
    }
    
    @objc func deleteInput(){
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
    
    @objc  func registerInputOne(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[2]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc  func registerInputTwo(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[3]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc  func registerInputThree(){
        var stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        stackRegisters[0] = stackRegisters[4]
        defaults.set(stackRegisters, forKey: "stackRegisters")
        updateDisplays()
    }
    
    @objc  func cancelInput(){
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
        
        let clearTapGesture = UITapGestureRecognizer(target: self, action: #selector(clearInput))
        clearTapGesture.numberOfTapsRequired = 1
        clearButton.addGestureRecognizer(clearTapGesture)
        
        let clearLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(clearButtonLongAction(gesture:)))
        clearLongTapGesture.minimumPressDuration = minimumPressDuration
        clearButton.addGestureRecognizer(clearLongTapGesture)
        
        let mainDisplayShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteInput))
        mainDisplayShortTapGesture.numberOfTapsRequired = 1
        mainDisplay.addGestureRecognizer(mainDisplayShortTapGesture)
        
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
