//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ajunpreet Bambrah on 2/2/15.
//  Copyright (c) 2015 Ajunpreet Bambrah. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
//    Not inheritance, this is a protocall
    private enum Op: Printable {
        case Operand(Double)
        case VoidOperation(String, Void -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .VoidOperation(let str, _):
                    return str
                case .UnaryOperation(let str, _):
                    return str
                case .BinaryOperation(let str, _):
                    return str
                case .Variable(let str):
                    return str
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues = Dictionary<String,Double>()
    
    init() {
        func learnOp(op : Op){
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("+",  +))
        learnOp(Op.BinaryOperation("÷",  {$1 / $0} ))
        learnOp(Op.BinaryOperation("-",  {$1 - $0} ))
        learnOp(Op.UnaryOperation ("√",  sqrt ))
        learnOp(Op.UnaryOperation ("sin",  {Double(sin($0))}))
        learnOp(Op.UnaryOperation ("cos",  {Double(cos($0))}))
        learnOp(Op.VoidOperation("π", {M_PI}))

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
            case .Variable(let str):
                    return (variableValues[str], remainingOps)
            } // End Switch
        } // End If

        return (nil, ops)
    }
    
    func reset(){
        opStack = [Op]()
    }
    
    func evaluate() -> Double? {
        let (result, remainingOps) = evaluate(opStack)
        println("\(opStack) = \(result)")
        return result
    }
    
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    var description: String {
        get {
            var res: String?
            var opStackClone = opStack
            while !opStackClone.isEmpty{
                let descResult = descriptionGet(opStackClone)
                opStackClone = descResult.remainingOps
//                Not the First Value
                if let result = res{
//                    the Result recieved now is valid
                    if let descResultBefore =  descResult.result{
                        res = "\(descResultBefore), \(result)"
                    }
                }else {
//                    the Result recieved now is valid
                    if let descResultFirst =  descResult.result{
                        res = descResultFirst
                    }
                }
            }
            
            if let result = res{
                return result
            }else {
                return ""
            }
//            if let result =  descriptionGet(opStack).result{
//                res = result
//            }else{
//                return ""
//            }
        }
    }
    
    private func descriptionGet(ops: [Op]) -> (result: String?, remainingOps: [Op]){
        if ops.isEmpty{
            println("empty")
            return ("?", ops)
        }
        
        var opStackClone = ops
        var op = opStackClone.removeLast()
        var res = ""
        println(op.description)
        switch op{
        case .Operand(let operand):
            res = operand.description
        case .VoidOperation(let operation, _):
            res = operation
        case .UnaryOperation(let operation, _):
            if let last = descriptionGet(opStackClone).result{
                res =  "\(operation)(\(last))"
            }
        case .BinaryOperation(let operation, _):
            let eval = descriptionGet(opStackClone)
            if let first = eval.result {
                if let last = descriptionGet(eval.remainingOps).result{
                    res = "\(last)\(operation)\(first)"
                }
            }
            
        case .Variable(let str):
            res = str
            
        } // End Switch
        return (res, opStackClone)
    }
}
