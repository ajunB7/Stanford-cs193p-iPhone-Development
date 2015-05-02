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
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("Value: \(digit)")
        if userIsInTheMiddleOfTypingANumber{
            display.text = ((digit == ".") && display.text!.rangeOfString(".") != nil) ? display.text! : display.text! + digit
        }else{
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }else {
                displayValue = nil
            }
            history.text = brain.description
        }

    }
    
    
    @IBAction func backSpace() {
        if count(display.text!) > 1 && userIsInTheMiddleOfTypingANumber{
            display.text = dropLast(display.text!)
        }else{
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func reset() {
        display.text = "0"
        history.text = ""
        brain.reset()
        userIsInTheMiddleOfTypingANumber = false
    }
    

    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        println(displayValue)
        if let displayValueText = displayValue {
            if let result = brain.pushOperand(displayValueText){
    //          displayValue = result
                history.text = history.text! + " " + display.text!
            }else {
                displayValue = 0
            }
        }
    }

    var displayValue:Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if let newValueText = newValue{
                display.text = "\(newValueText)"
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

