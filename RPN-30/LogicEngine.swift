//
//  LogicEngine.swift
//  RPN-30
//
//  Created by Ashok Khanna on 1/2/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

extension Calculator {
    
    // MARK: Operations and Number Entry

    func processOperation(_ operation: String){
        
        // Function is called whenever a operator key is entered
        
        stackAutoLift = true
        
        var unaryAction = false
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        let yRegister = stackRegisters[1]
        
        var xRegisterNew: Double
        
        switch operation {
            
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
            stackAutoLift = true // CHS is not an operation that should trigger stackautolift (removed this)
            unaryAction = true
            
        case "EE":
            xRegisterNew = yRegister * pow(10.0, Double(xRegister))
        case "x√y":
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
            
        // New functions added Friday 10 April 2020
        case "sin x":
            xRegisterNew = sin(xRegister)
            
        case "asin x":
            xRegisterNew = asin(xRegister)
            unaryAction = true

        case "x!":
            
            var xRegisterInt: Int = 0
            
            if xRegister >= 0.0 && xRegister < Double(Int.max) {
                xRegisterInt = Int(xRegister.rounded())
            }
            
            if xRegisterInt == 0 {
                xRegisterNew = 1
            } else {
                
                var a: Double = 1
                for i in 1...xRegisterInt {
                    a *= Double(i)
                }
                
                xRegisterNew = a
                
            }

            unaryAction = true
        
        default:
            return
        }
        
        // Set L register values
        defaults.set(xRegister, forKey: "lRegisterX")
        defaults.set(yRegister, forKey: "lRegisterY")
        defaults.set(operation, forKey: "lOperator")
        defaults.set(unaryAction, forKey: "lUnaryAction")
        
        if !unaryAction {
            dropStackRegistersAfterBinaryOperation()
        }
        
        amendStackRegister(value: xRegisterNew, at: 0)
        if operation != "chs" {
            UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
        }
        isNewNumberEntry = true
        
    }
    
    func processStore(_ sender: CalculatorButton){
 
    }
    
    func processStoreRecall(_ sender: CalculatorButton) {

        // Trying to make STORE/RECALL to register 9 write/read iOS Clipboard
        // Warning: mash may not know what he is doing!!
        
        let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if storeBalance {

            if sender.digitValue == 9 { // write to iOS clipboard
                UIPasteboard.general.string = stackRegistersOld[0]
            } else if sender.digitValue != 0 {
                defaults.set(stackRegistersOld[0], forKey: sender.digitString!)
            }
            isNewNumberEntry = true
            storeBalance = false
            
        }

        if recallBalance {
            
            if stackAutoLift {
                liftStackRegisters()
                stackAutoLift = false
                updateYRegisterDisplay()
                updateStackDisplay()
            }
            
            if sender.digitValue == 9 { // read from iOS clipboard
                // Probably need to test that clipboard content is a number, otherwise convert to 0 or give error
                let xRegisterNew = UIPasteboard.general.string
                amendStackRegister(value: xRegisterNew, at: 0)
            } else if sender.digitValue != 0 {
                let xRegisterNew = defaults.double(forKey: sender.digitString!)
                amendStackRegister(value: xRegisterNew, at: 0)
            }
            
            isNewNumberEntry = true
            recallBalance = false
            
            clearLastRegisters()
        }

    
    }
    
    func processDigit(_ sender: CalculatorButton){
        
        var stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if stackAutoLift {
            liftStackRegisters()
            stackAutoLift = false
            clearLastRegisters()
            updateYRegisterDisplay()
            updateStackDisplay()
        }
        
        if isNewNumberEntry && stackRegistersOld[0] != 0.0 {
            amendStackRegister(value: 0.0, at: 0)
            isNewNumberEntry = false
            UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
        }
        
        if isNewNumberEntry && stackRegistersOld[0] == 0.0 {
            isNewNumberEntry = false
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

    }
    
    func decimalInput(){
        // No override of isNewNumberEntry because action depends on state of xRegister
        
        var xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        
        if isNewNumberEntry {
            if stackAutoLift {
                liftStackRegisters()
                stackAutoLift = false
                clearLastRegisters()
                updateYRegisterDisplay()
                updateStackDisplay()
            }
            
            isNewNumberEntry = false
            amendStackRegister(value: 0.0, at: 0)
            xRegisterDecimals = 0
        }

        
        if xRegisterDecimals == 0 {
            UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
        }
                
        /* Not required I think as using delete tap to remove decimals
            else if xRegisterDecimals == 1 {
            UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
        } */
    }
    
    
    //MARK: Stack Manipulation Methods
    
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
        
        /*
        defaults.set(stackRegistersNew[1], forKey: "lRegisterY")
        defaults.set("", forKey: "lOperator")
        defaults.set(false, forKey: "lUnaryAction")
         */
        
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
    
    func dropStackRegistersAfterBinaryOperation(){
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
    
    func clearStack(){
        var stackRegisters = [Double]()
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        stackRegisters.append(0.0)
        defaults.set(stackRegisters, forKey: "stackRegisters")
        
        isNewNumberEntry = true
        stackAutoLift = false // User does not expect this behaviour when accessing calculator for first time
        storeBalance = false
        recallBalance = false
    }
    
    func clearLastRegisters(){
        defaults.set(0.0, forKey: "lRegisterY")
        defaults.set(0.0, forKey: "lRegisterX")
        defaults.set("", forKey: "lOperator")
        defaults.set(false, forKey: "lUnaryAction")
    }
    
}
