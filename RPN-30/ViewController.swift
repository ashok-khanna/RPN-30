//
//  ViewController.swift
//  RPN-30
//
//  Created by Ashok Khanna on 19/1/19.
//  Copyright © 2019 Ashok Khanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK: Initilization
    @IBOutlet weak var calculatorView: Calculator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calculatorHeight = self.view.bounds.height - 96.0
        let calculatorWidth = self.view.bounds.width - 32.0
        calculatorView.actualButtonHeight = calculatorHeight * calculatorView.buttonHeight
        calculatorView.actualButtonWidth = calculatorWidth * calculatorView.buttonWidth
        
        calculatorView.buttonVerticalPadding = CGFloat(calculatorView.spacingBetweenButtonsAsPercentageOfButton / calculatorView.colHeight) * calculatorHeight
        calculatorView.buttonHorizontalPadding = CGFloat(calculatorView.spacingBetweenButtonsAsPercentageOfButton / calculatorView.rowWidth) * calculatorWidth
        

        
        calculatorView.setupCalculator()
        
        calculatorView.layoutIfNeeded()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        
    }
 
}

