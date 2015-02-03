//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ajunpreet Bambrah on 2/2/15.
//  Copyright (c) 2015 Ajunpreet Bambrah. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op {
        case Operand(Double)
        case VoidOperation(String, Void -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["x"] = Op.BinaryOperation("x",  *)
        knownOps["+"] = Op.BinaryOperation("+",  +)
        knownOps["÷"] = Op.BinaryOperation("÷",  {$1 / $0} )
        knownOps["-"] = Op.BinaryOperation("-",  {$1 - $0} )
        knownOps["÷"] = Op.UnaryOperation ("√",  sqrt )
        knownOps["sin"] = Op.UnaryOperation ("sin",  {Double(sin($0))})
        knownOps["cos"] = Op.UnaryOperation ("cos",  {Double(cos($0))})
        knownOps["π"] = Op.VoidOperation("π", {M_PI})

    }
    
//    Returns 2 things in a tuple
//    In Swift Arrays are structs(no superClasses) and passed by value (readOnly)
//    Classes(Double, ints...) are generally passed by reference
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
//    _ is used when you don't care what that param is
            case .VoidOperation(_, let operation):
                return (operation(), remainingOps)

            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }

            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            } // End Switch
        } // End If

        return (nil, ops)
    }
    
    func reset(){
        opStack = [Op]()
    }
    
    func evaluate() -> Double? {
        let (result, remainingOps) = evaluate(opStack)
        return result
    }
    
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
