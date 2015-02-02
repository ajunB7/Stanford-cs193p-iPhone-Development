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
        println("Value: \(digit)")
        if userIsInTheMiddleOfTypingANumber{
            display.text = ((digit == ".") && display.text!.rangeOfString(".") != nil) ? display.text! : display.text! + digit
        }else{
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTypingANumber = true
        }
        

    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        history.text = history.text! + " " + operation
        
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
            performOperation {M_PI}
        default: break
        }
    }
    
    
    @IBAction func backSpace() {
        if countElements(display.text!) > 1 && userIsInTheMiddleOfTypingANumber{
            display.text = dropLast(display.text!)
        }else{
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
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
    
    func performOperation(operation: Double -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Void -> Double){
        displayValue = operation()
        enter()
    }

    var operandStack: [Double] = []
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        history.text = history.text! + " " + display.text!
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

