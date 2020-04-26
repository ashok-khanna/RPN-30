// Updates output displays for calculator. Does not save/modify any values

import UIKit

extension Calculator {
    
    func updateXRegisterDisplayForFunction(_ functionTitle: String){
        xRegisterDisplay.text = functionTitle
    }
    
    func updateDisplays(afterOperation: Bool, onClear: Bool = false){
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        if afterOperation {
            updateStackDisplay()
            updateYRegisterDisplay()
            updateXRegisterDisplay(resultMode: true)
            updateLastDisplayAfterOperation(isUnary: defaults.bool(forKey: "lUnaryAction"))
        } else {
            if onClear {
                updateStackDisplayToNil(stackRegisters)
                updateYRegisterDisplayToNil(stackRegisters[1])
                updateXRegisterDisplayToNil(stackRegisters[0])
            } else {
                updateStackDisplay()
                updateYRegisterDisplay()
                updateXRegisterDisplay(resultMode: true)
            }
            updateLastDisplayToNil()
        }
    }
    
    func updateXRegisterDisplayToNil(_ xRegister: Double){
        if xRegister == 0.0 { xRegisterDisplay.text = ""
        } else { updateXRegisterDisplay(resultMode: true) }
    }
    
    func updateYRegisterDisplayToNil(_ yRegister: Double){
        if yRegister == 0.0 { yRegisterDisplay.text = "" }
        else { updateYRegisterDisplay() }
    }
    
    func updateStackDisplayToNil(_ stackRegistersPassed: [Double]){
        
        var stackRegisters = stackRegistersPassed
        stackRegisters.removeFirst()
        stackRegisters.removeFirst()
        
        var emptyStack = true
        
        for double in stackRegisters {
            if double != 0.0 {
                emptyStack = false
                break
            }
        }
        
        if emptyStack { sRegisterDisplay.text = "" } else { updateStackDisplay() }
    }
    
    func updateLastDisplayToNil(){
        lRegisterDisplay.text = ""
    }
    
    func updateXRegisterDisplay(resultMode: Bool = false){
        
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let xRegister = stackRegisters[0]
        let xRegisterNS = NSNumber(value: xRegister)
        var xRegisterString: String
                
        let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
        if resultMode {
            if(UserDefaults.standard.bool(forKey: "use_significant")){
                xRegisterString = formatterScientificXY.string(from: xRegisterNS) ?? ""
            } else {
                xRegisterString = formatterDecimalXY.string(from: xRegisterNS) ?? ""
            }
        }
        else {
            if xRegisterDecimals <= 1 {
                formatterXRegister.minimumFractionDigits = xRegisterDecimals
                formatterXRegister.maximumFractionDigits = xRegisterDecimals
            }
            else {
                formatterXRegister.minimumFractionDigits = xRegisterDecimals - 1
                formatterXRegister.maximumFractionDigits = xRegisterDecimals - 1
                
            }
            xRegisterString = formatterXRegister.string(from: xRegisterNS) ?? ""
        }
                
        xRegisterDisplay.text = xRegisterString
    }
    

    
    func updateYRegisterDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let yRegister = stackRegisters[1]
        var yRegisterString: String
        
        if(UserDefaults.standard.bool(forKey: "use_significant")){
            yRegisterString = formatterScientificXY.string(from: NSNumber(value: yRegister)) ?? ""
        } else {
            yRegisterString = formatterDecimalXY.string(from: NSNumber(value: yRegister)) ?? ""
        }

        
        if yRegisterString == "" {
            yRegisterDisplay.text = ""
        } else {
            yRegisterDisplay.text = yRegisterString
        }
        
    }
    

    
    func updateLastDisplayAfterOperation(isUnary: Bool){
        
        let lRegisterX = defaults.double(forKey: "lRegisterX")
        let lRegisterY = defaults.double(forKey: "lRegisterY")
        var lOperatorString = defaults.string(forKey: "lOperator") ?? ""

        let lRegisterXNS = NSNumber(value: lRegisterX)
        let lRegisterYNS = NSNumber(value: lRegisterY)
        
        var lRegisterYString, lRegisterXString : String
        
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
        
        switch lOperatorString {
            
            case "+":
                lRegisterDisplay.text = lRegisterYString + " " + lOperatorString + " " + lRegisterXString
            case "−":
                lRegisterDisplay.text = lRegisterYString + " " + lOperatorString + " " + lRegisterXString
            case "x":
                lRegisterDisplay.text = lRegisterYString + " " + lOperatorString + " " + lRegisterXString
            case "÷":
                lRegisterDisplay.text = lRegisterYString + " " + lOperatorString + " " + lRegisterXString
            case "x!":
                lRegisterDisplay.text = lRegisterXString + "!"
            case "√x":
                lRegisterDisplay.text = "√" + lRegisterXString
            case "x√y":
                lRegisterDisplay.text = lRegisterXString + " " + "√" + " " + lRegisterYString
            case "1/x":
                lRegisterDisplay.text = "1 ÷ " + lRegisterXString
            case "% Δ":
                lRegisterDisplay.text = "% change  of (" + lRegisterXString + " - " + lRegisterYString + ")"
            case "e^x":
                lRegisterDisplay.text = "e ^ " + lRegisterXString
            case "ln x":
                lRegisterDisplay.text = "ln(" + lRegisterXString + ")"
            case "log10 x":
                lRegisterDisplay.text = "log10(" + lRegisterXString + ")"
            case "log2 x":
                lRegisterDisplay.text = "log2(" + lRegisterXString + ")"
            case "y^x":
                lRegisterDisplay.text = lRegisterYString + " " + "^" + " " + lRegisterXString
            case "TRIG":
                switch lRegisterXString {
                case "1":
                    lRegisterDisplay.text = "sin(" + lRegisterYString + ")"
                case "2":
                    lRegisterDisplay.text = "cos(" + lRegisterYString + ")"
                case "3":
                    lRegisterDisplay.text = "tan(" + lRegisterYString + ")"
                case "4":
                    lRegisterDisplay.text = "asin(" + lRegisterYString + ")"
                case "5":
                    lRegisterDisplay.text = "acos(" + lRegisterYString + ")"
                case "6":
                    lRegisterDisplay.text = "atan(" + lRegisterYString + ")"                    
                case "7":
                    lRegisterDisplay.text = "pi"
                case "8":
                    lRegisterDisplay.text = "D→R"
                case "9":
                    lRegisterDisplay.text = "R→D"
                default:
                    return
                }
                
            case "sin x":
                lRegisterDisplay.text = "sin(" + lRegisterYString + ")"
            case "cos x":
                lRegisterDisplay.text = "cos(" + lRegisterYString + ")"
            case "tan x":
                lRegisterDisplay.text = "tan(" + lRegisterYString + ")"
            case "asin x":
                lRegisterDisplay.text = "asin(" + lRegisterYString + ")"
            case "acos x":
                lRegisterDisplay.text = "acos(" + lRegisterYString + ")"
            case "atan x":
                lRegisterDisplay.text = "atan(" + lRegisterYString + ")"
            default:
                if isUnary {
                    lRegisterDisplay.text = lOperatorString + "  " + lRegisterXString
                } else {
                   lRegisterDisplay.text = lRegisterYString + "  " + lOperatorString + "  " + lRegisterXString
                }
        }
        
    }
    
    func updateStackDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let secondRegister = stackRegisters[2]
        let thirdRegister = stackRegisters[3]
        let fourthRegister = stackRegisters[4]
        
        let secondRegisterNS = NSNumber(value: secondRegister)
        let thirdRegisterNS = NSNumber(value: thirdRegister)
        let fourthRegisterNS = NSNumber(value: fourthRegister)
        
        var secondRegisterString, thirdRegisterString, fourthRegisterString : String
        
        if(abs(secondRegister) > maxNumberLengthForSRegister) {
            secondRegisterString = self.formatterScientific.string(from: secondRegisterNS) ?? ""
        } else {
            secondRegisterString = self.formatterDecimal.string(from: secondRegisterNS) ?? ""
        }
        
        if(abs(thirdRegister) > maxNumberLengthForSRegister) {
            thirdRegisterString = self.formatterScientific.string(from: thirdRegisterNS) ?? ""
        } else {
            thirdRegisterString = self.formatterDecimal.string(from: thirdRegisterNS) ?? ""
        }
        
        if(abs(fourthRegister) > maxNumberLengthForSRegister) {
            fourthRegisterString = self.formatterScientific.string(from: fourthRegisterNS) ?? ""
        } else {
            fourthRegisterString = self.formatterDecimal.string(from: fourthRegisterNS) ?? ""
        }
        
        sRegisterDisplay.text = fourthRegisterString + "\n" + "\n" + thirdRegisterString + "\n" + "\n" + secondRegisterString
    }
}
