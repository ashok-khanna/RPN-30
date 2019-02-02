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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculatorView.actualButtonHeight = calculatorView.bounds.height * calculatorView.buttonHeight
        calculatorView.actualButtonWidth = calculatorView.bounds.width * calculatorView.buttonWidth
        
        print(calculatorView.bounds.height)
        print(calculatorView.bounds.width)
        print("test")
    }
 
}

