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
            
        case "y EE x":
            xRegisterNew = yRegister * pow(10.0, Double(xRegister))
        case "√x":
            xRegisterNew = sqrt(xRegister)
            unaryAction = true
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
            
            // New functions added since Friday 10 April 2020
            
        case "x!":
            xRegisterNew = tgamma(xRegister + 1)
            unaryAction = true
        case "log10 x":
            xRegisterNew = log10(x)
            unaryAction = true
        case "log2 x":
            xRegisterNew = log2(x)
            unaryAction = true

            // Trig functions (from second page)
            // Treat these unary actions as if they were not so that they roll the stack 
        case "TRIG":
            switch xRegister {
            case "1":
                xRegisterNew = sin(yRegister)
            case "2":
                xRegisterNew = cos(yRegister)
            case "3":
                xRegisterNew = tan(yRegister)
            case "4":
                xRegisterNew = asin(yRegister)
            case "5":
                xRegisterNew = acos(yRegister)
            case "6":
                xRegisterNew = atan(yRegister)
            case "7":
                xRegisterNew = M_PI
                unaryAction = true
            case "8":
                xRegisterNew = M_PI * yRegister / 180.0
            case "9":
                xRegisterNew = 180.0 * yRegister / M_PI
            default:
                return
            }

        case "sin x":
            xRegisterNew = sin(yRegister)
            unaryAction = true
        case "cos x":
            xRegisterNew = cos(yRegister)
            unaryAction = true
        case "tan x":
            xRegisterNew = tan(yRegister)
            unaryAction = true
        case "asin x":
            xRegisterNew = asin(yRegister)
            unaryAction = true
        case "acos x":
            xRegisterNew = acos(yRegister)
            unaryAction = true
        case "atan x":
            xRegisterNew = atan(yRegister)
            unaryAction = true
        case "pi":
            xRegisterNew = M_PI
            unaryAction = true
        case "D→R":
            xRegisterNew = M_PI * yRegister / 180.0
            unaryAction = true
        case "R→D":
            xRegisterNew = 180.0 * yRegister / M_PI
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
        
        let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if storeBalance {
            
            if sender.digitValue != 0 && sender.digitValue != 9 {
                defaults.set(stackRegistersOld[0], forKey: sender.digitString!)
            }
            isNewNumberEntry = true
            storeBalance = false
            
            if sender.digitValue == 9 {
                UIPasteboard.general.string = String(stackRegistersOld[0])
            }
            
        }

        if recallBalance {
            
            if stackAutoLift {
                liftStackRegisters()
                stackAutoLift = false
                updateYRegisterDisplay()
                updateStackDisplay()
            }
            
            if sender.digitValue != 0 && sender.digitValue != 9 {
                let xRegisterNew = defaults.double(forKey: sender.digitString!)
                amendStackRegister(value: xRegisterNew, at: 0)
            }
            
            if sender.digitValue == 9 {
                
                if let myString = UIPasteboard.general.string {
                    let xRegisterNew = Double(myString) ?? 0.0
                    amendStackRegister(value: xRegisterNew, at: 0)
                }

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
