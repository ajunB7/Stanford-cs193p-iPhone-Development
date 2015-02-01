//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Ajunpreet Bambrah on 1/31/15.
//  Copyright © 2015 Ajunpreet Bambrah. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("Value: \(digit)")
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }

    }

}

