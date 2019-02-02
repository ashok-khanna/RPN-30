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
 
        if resultMode { xRegisterString = formatterDecimal.string(from: xRegisterNS) ?? "" }
        else {
            if xRegisterDecimals <= 1 { formatterXRegister.minimumFractionDigits = xRegisterDecimals }
            else { formatterXRegister.minimumFractionDigits = xRegisterDecimals - 1 }
            xRegisterString = formatterXRegister.string(from: xRegisterNS) ?? ""
        }
        
        xRegisterDisplay.text = xRegisterString
    }
    

    
    func updateYRegisterDisplay(){
        let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
        
        let yRegister = stackRegisters[1]
        let yRegisterString = formatterDecimal.string(from: NSNumber(value: yRegister)) ?? ""
        
        if yRegisterString == "" {
            yRegisterDisplay.text = ""
        } else {
            yRegisterDisplay.text = yRegisterString
        }
        
    }
    

    
    func updateLastDisplayAfterOperation(isUnary: Bool){
        
        let lRegisterX = defaults.double(forKey: "lRegisterX")
        let lRegisterY = defaults.double(forKey: "lRegisterY")
        let lOperatorString = defaults.string(forKey: "lOperator") ?? ""

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
        
        if isUnary {
            lRegisterDisplay.text = lOperatorString + "  " + lRegisterXString
        } else {
            lRegisterDisplay.text = lRegisterYString + "  " + lOperatorString + "  " + lRegisterXString
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
