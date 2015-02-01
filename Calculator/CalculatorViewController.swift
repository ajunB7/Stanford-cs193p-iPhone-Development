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

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        history.text = history.text! + " " + digit
        println("Value: \(digit)")
        if userIsInTheMiddleOfTypingANumber{
           display.text = ((digit == ".") && display.text!.rangeOfString(".") != nil) ?  display.text! : display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }

    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        history.text = history.text! + " " + operation
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        switch operation{
        case "x":
            performOperation {$0 * $1}
        case "÷":
            performOperation {$0 / $1}
        case "+":
            performOperation {$0 + $1}
        case "-":
            performOperation {$0 - $1}
        case "√":
            performOperation {sqrt($0)}
        case "sin":
            performOperation {Double(sin($0))}
        case "cos":
            performOperation {Double(cos($0))}
        case "π":
            display.text = "\(M_PI)"
            enter()
        default: break
        }
    }
    
    @IBAction func reset() {
        display.text = "0"
        history.text = ""
        operandStack = []
        userIsInTheMiddleOfTypingANumber = false
    }
    
    func performOperation(operation: (Double,Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double){
        println("performing sqrt")
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    var operandStack: [Double] = []
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack: \(operandStack)")
    }
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

