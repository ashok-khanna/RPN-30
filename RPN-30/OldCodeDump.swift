//
//  OldCodeDump.swift
//  RPN-30
//
//  Created by Ashok Khanna on 26/1/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//


/* OLD Stack Manipluation code
 
 @objc private func enterInput(){
 
 let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
 
 liftStackRegisters(xRegisterNew: stackRegisters[0])
 
 isNewNumberEntry = true
 updateNumberDisplay()
 }
 
 @objc private func deleteInput(){
 
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 
 if xRegisterDecimals <= 1 {
 let xRegisterNew = Double(floor(UserDefaults.standard.double(forKey: "xRegister")/10))
 UserDefaults.standard.set(xRegisterNew, forKey: "xRegister")
 
 } else if xRegisterDecimals > 1 {
 let intermediateX = floor(UserDefaults.standard.double(forKey: "xRegister") * pow(10.0, Double(xRegisterDecimals - 2)))
 print(intermediateX)
 
 let xRegisterNew = Double(intermediateX / pow(10.0, Double(xRegisterDecimals - 2)))
 UserDefaults.standard.set(xRegisterNew, forKey: "xRegister")
 
 UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
 }
 
 if xRegisterDecimals <= 2 {
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 updateNumberDisplay()
 }
 
 @objc private func decimalInput(){
 
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 
 if xRegisterDecimals == 0 {
 UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
 } else if xRegisterDecimals == 1 {
 UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
 }
 }
 
 
 
 
 @objc private func clearInput(){
 
 if UserDefaults.standard.double(forKey: "xRegister") == 0 {
 if UserDefaults.standard.double(forKey: "yRegister") == 0 {
 if UserDefaults.standard.double(forKey: "zRegister") == 0 {
 UserDefaults.standard.set(0.0, forKey: "tRegister")
 } else {
 UserDefaults.standard.set(0.0, forKey: "zRegister")
 }
 } else {
 UserDefaults.standard.set(0.0, forKey: "yRegister")
 }
 } else {
 UserDefaults.standard.set(0.0, forKey: "xRegister")
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 updateNumberDisplay()
 }
 
 private func numberInput(_ sender: CalculatorButton){
 
 cancelTopOnPop()
 
 if isNewNumberEntry {
 let xRegister = UserDefaults.standard.double(forKey: "xRegister")
 liftStackRegisters(xRegisterNew: xRegister)
 UserDefaults.standard.set(0.0, forKey: "xRegister")
 isNewNumberEntry = false
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 var xRegisterNew: Double?
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 let xRegister = UserDefaults.standard.double(forKey: "xRegister")
 if  xRegisterDecimals == 0 {
 xRegisterNew = xRegister*10.0 + sender.digitValue!
 } else if xRegisterDecimals > 0 {
 xRegisterNew = xRegister + pow(10.0, -1.0 * Double(xRegisterDecimals)) * sender.digitValue!
 UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
 } else {
 xRegisterNew = xRegister
 }
 
 UserDefaults.standard.set(xRegisterNew!, forKey: "xRegister")
 updateNumberDisplay()
 
 }
 
 private func liftStackRegisters(xRegisterNew: Double){
 
 // New code - not yet active
 let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
 var stackRegistersNew = [Double]()
 stackRegistersNew.append(xRegisterNew)
 stackRegistersNew.append(contentsOf: stackRegistersOld)
 defaults.set(stackRegistersNew, forKey: "stackRegisters")
 
 /*
 let yRegisterOld = UserDefaults.standard.double(forKey: "yRegister")
 let zRegisterOld = UserDefaults.standard.double(forKey: "zRegister")
 
 UserDefaults.standard.set(xRegister, forKey: "yRegister")
 UserDefaults.standard.set(yRegisterOld, forKey: "zRegister")
 UserDefaults.standard.set(zRegisterOld, forKey: "tRegister")
 
 */
 }
 
 private func dropStackRegisters(){
 
 // New code - not yet active
 var stackRegistersNew = defaults.array(forKey: "stackRegisters") as! [Double]
 stackRegistersNew.removeFirst()
 defaults.set(stackRegistersNew, forKey: "stackRegisters")
 
 // Old code
 let zRegisterOld = UserDefaults.standard.double(forKey: "zRegister")
 let tRegisterOld = UserDefaults.standard.double(forKey: "tRegister")
 
 UserDefaults.standard.set(zRegisterOld, forKey: "yRegister")
 UserDefaults.standard.set(tRegisterOld, forKey: "zRegister")
 }    @objc private func enterInput(){
 
 let stackRegisters = defaults.array(forKey: "stackRegisters") as! [Double]
 
 liftStackRegisters(xRegisterNew: stackRegisters[0])
 
 isNewNumberEntry = true
 updateNumberDisplay()
 }
 
 @objc private func deleteInput(){
 
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 
 if xRegisterDecimals <= 1 {
 let xRegisterNew = Double(floor(UserDefaults.standard.double(forKey: "xRegister")/10))
 UserDefaults.standard.set(xRegisterNew, forKey: "xRegister")
 
 } else if xRegisterDecimals > 1 {
 let intermediateX = floor(UserDefaults.standard.double(forKey: "xRegister") * pow(10.0, Double(xRegisterDecimals - 2)))
 print(intermediateX)
 
 let xRegisterNew = Double(intermediateX / pow(10.0, Double(xRegisterDecimals - 2)))
 UserDefaults.standard.set(xRegisterNew, forKey: "xRegister")
 
 UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
 }
 
 if xRegisterDecimals <= 2 {
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 updateNumberDisplay()
 }
 
 @objc private func decimalInput(){
 
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 
 if xRegisterDecimals == 0 {
 UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
 } else if xRegisterDecimals == 1 {
 UserDefaults.standard.set(xRegisterDecimals - 1, forKey: "xRegisterDecimals")
 }
 }
 
 
 
 
 @objc private func clearInput(){
 
 if UserDefaults.standard.double(forKey: "xRegister") == 0 {
 if UserDefaults.standard.double(forKey: "yRegister") == 0 {
 if UserDefaults.standard.double(forKey: "zRegister") == 0 {
 UserDefaults.standard.set(0.0, forKey: "tRegister")
 } else {
 UserDefaults.standard.set(0.0, forKey: "zRegister")
 }
 } else {
 UserDefaults.standard.set(0.0, forKey: "yRegister")
 }
 } else {
 UserDefaults.standard.set(0.0, forKey: "xRegister")
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 updateNumberDisplay()
 }
 
 private func numberInput(_ sender: CalculatorButton){
 
 cancelTopOnPop()
 
 if isNewNumberEntry {
 let xRegister = UserDefaults.standard.double(forKey: "xRegister")
 liftStackRegisters(xRegisterNew: xRegister)
 UserDefaults.standard.set(0.0, forKey: "xRegister")
 isNewNumberEntry = false
 UserDefaults.standard.set(0, forKey: "xRegisterDecimals")
 }
 
 var xRegisterNew: Double?
 let xRegisterDecimals = UserDefaults.standard.integer(forKey: "xRegisterDecimals")
 let xRegister = UserDefaults.standard.double(forKey: "xRegister")
 if  xRegisterDecimals == 0 {
 xRegisterNew = xRegister*10.0 + sender.digitValue!
 } else if xRegisterDecimals > 0 {
 xRegisterNew = xRegister + pow(10.0, -1.0 * Double(xRegisterDecimals)) * sender.digitValue!
 UserDefaults.standard.set(xRegisterDecimals + 1, forKey: "xRegisterDecimals")
 } else {
 xRegisterNew = xRegister
 }
 
 UserDefaults.standard.set(xRegisterNew!, forKey: "xRegister")
 updateNumberDisplay()
 
 }
 
 private func liftStackRegisters(xRegisterNew: Double){
 
 // New code - not yet active
 let stackRegistersOld = defaults.array(forKey: "stackRegisters") as! [Double]
 var stackRegistersNew = [Double]()
 stackRegistersNew.append(xRegisterNew)
 stackRegistersNew.append(contentsOf: stackRegistersOld)
 defaults.set(stackRegistersNew, forKey: "stackRegisters")
 
 /*
 let yRegisterOld = UserDefaults.standard.double(forKey: "yRegister")
 let zRegisterOld = UserDefaults.standard.double(forKey: "zRegister")
 
 UserDefaults.standard.set(xRegister, forKey: "yRegister")
 UserDefaults.standard.set(yRegisterOld, forKey: "zRegister")
 UserDefaults.standard.set(zRegisterOld, forKey: "tRegister")
 
 */
 }
 
 private func dropStackRegisters(){
 
 // New code - not yet active
 var stackRegistersNew = defaults.array(forKey: "stackRegisters") as! [Double]
 stackRegistersNew.removeFirst()
 defaults.set(stackRegistersNew, forKey: "stackRegisters")
 
 // Old code
 let zRegisterOld = UserDefaults.standard.double(forKey: "zRegister")
 let tRegisterOld = UserDefaults.standard.double(forKey: "tRegister")
 
 UserDefaults.standard.set(zRegisterOld, forKey: "yRegister")
 UserDefaults.standard.set(tRegisterOld, forKey: "zRegister")
 }
 
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
 myMutableString = NSMutableAttributedString(string: "\n . \n RECALL", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:6))
 
 decimalButton.setAttributedTitle(myMutableString, for: .normal)
 decimalButton.titleLabel?.numberOfLines = 0
 
 // Text label for zeroButton
 myMutableString = NSMutableAttributedString(string: "\n 0 \n STORE", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:5))
 
 zeroButton.setAttributedTitle(myMutableString, for: .normal)
 zeroButton.titleLabel?.numberOfLines = 0
 
 // Text label for oneButton
 myMutableString = NSMutableAttributedString(string: "\n 1 \n HELP", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:4))
 
 oneButton.setAttributedTitle(myMutableString, for: .normal)
 oneButton.titleLabel?.numberOfLines = 0
 
 // Text label for twoButton
 myMutableString = NSMutableAttributedString(string: "\n 2 \n POWER", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:5))
 
 twoButton.setAttributedTitle(myMutableString, for: .normal)
 twoButton.titleLabel?.numberOfLines = 0
 
 // Text label for threeButton
 myMutableString = NSMutableAttributedString(string: "\n 3 \n PCT TOT", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:7))
 
 threeButton.setAttributedTitle(myMutableString, for: .normal)
 threeButton.titleLabel?.numberOfLines = 0
 
 // Text label for fourButton
 myMutableString = NSMutableAttributedString(string: "\n 4 \n CAGR", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:4))
 
 fourButton.setAttributedTitle(myMutableString, for: .normal)
 fourButton.titleLabel?.numberOfLines = 0
 
 // Text label for fiveButton
 myMutableString = NSMutableAttributedString(string: "\n 5 \n CF0 \n RECIP", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:4,length:8))
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:12,length:5))
 
 fiveButton.setAttributedTitle(myMutableString, for: .normal)
 fiveButton.titleLabel?.numberOfLines = 0
 
 // Text label for sixButton
 myMutableString = NSMutableAttributedString(string: "\n 6 \n PCT CHG", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:7))
 
 sixButton.setAttributedTitle(myMutableString, for: .normal)
 sixButton.titleLabel?.numberOfLines = 0
 
 // Text table for sevenButton
 myMutableString = NSMutableAttributedString(string: "\n 7 \n LAST", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:4))
 
 sevenButton.setAttributedTitle(myMutableString, for: .normal)
 sevenButton.titleLabel?.numberOfLines = 0
 
 // Text label for eightButton
 myMutableString = NSMutableAttributedString(string: "\n 8 \n SWAP", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:4))
 
 eightButton.setAttributedTitle(myMutableString, for: .normal)
 eightButton.titleLabel?.numberOfLines = 0
 
 // Text label for nineButton
 myMutableString = NSMutableAttributedString(string: "\n 9 \n PCT", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: digitTitleSize, NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
 
 myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: functionTitleColor, NSAttributedString.Key.font: functionTitleSize], range: NSRange(location:6,length:3))
 
 nineButton.setAttributedTitle(myMutableString, for: .normal)
 nineButton.titleLabel?.numberOfLines = 0
 
 */

/*
 
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
 
 let oneShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(oneInput))
 oneShortTapGesture.numberOfTapsRequired = 1
 oneButton.addGestureRecognizer(oneShortTapGesture)
 
 let twoShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(twoInput))
 twoShortTapGesture.numberOfTapsRequired = 1
 twoButton.addGestureRecognizer(twoShortTapGesture)
 
 let threeShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(threeInput))
 threeShortTapGesture.numberOfTapsRequired = 1
 threeButton.addGestureRecognizer(threeShortTapGesture)
 
 let fourShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(fourInput))
 fourShortTapGesture.numberOfTapsRequired = 1
 fourButton.addGestureRecognizer(fourShortTapGesture)
 
 let fiveShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(fiveInput))
 fiveShortTapGesture.numberOfTapsRequired = 1
 fiveButton.addGestureRecognizer(fiveShortTapGesture)
 
 let sixShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(sixInput))
 sixShortTapGesture.numberOfTapsRequired = 1
 sixButton.addGestureRecognizer(sixShortTapGesture)
 
 let sevenShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(sevenInput))
 sevenShortTapGesture.numberOfTapsRequired = 1
 sevenButton.addGestureRecognizer(sevenShortTapGesture)
 
 let eightShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(eightInput))
 eightShortTapGesture.numberOfTapsRequired = 1
 eightButton.addGestureRecognizer(eightShortTapGesture)
 
 let nineShortTapGesture = UITapGestureRecognizer(target: self, action: #selector(nineInput))
 nineShortTapGesture.numberOfTapsRequired = 1
 nineButton.addGestureRecognizer(nineShortTapGesture)
 
 */
