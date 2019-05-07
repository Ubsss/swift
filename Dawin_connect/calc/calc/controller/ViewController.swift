//
//  ViewController.swift
//  calc
//
//  Created by Uchechukwu Uboh on 4/27/19.
//  Copyright © 2019 Uchechukwu Uboh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var feedback: UILabel!
    
    // Arithmetic operations tag numbers from UI
    let posNeg = -8
    let mod = -7
    let divide = -6
    let multiply = -5
    let subtract = -4
    let add = -3
    
    // Holds selected operation
    var operations: Int = 0
    
    // Input values checks
    var numb1Filled: Bool = false
    var numb2Filled: Bool = false
    var decimalInOperand: Bool = false
    
    // Holds first operand
    var numb1 = 0.0
    // Holds second operand
    var numb2 = 0.0
    
    // Shows on the screen
    var displayText: String = "0"
    var feedbackText: String = "Welcome to MyCalc! 😄"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // updates the display view - DONE
    func updateDisplay(){
        feedback.text = feedbackText
        display.text = displayText
    }
    
    // check the numbers selected - DONE
    @IBAction func numPress(sender: UIButton){
        if (sender.tag >= -1 && sender.tag <= 9){
        if(displayText.count <= 8){
            if(displayText == "0"){
                displayText = ""
            }
            
            if(sender.tag == -1){
                if(decimalInOperand == false){
                    decimalInOperand = true
                    if(displayText == ""){
                        displayText += "0"
                        updateDisplay()
                    }
                    for i in displayText{
                        if i == "."{
                            return
                        }
                    }
                    displayText += "."
                    updateDisplay()
                    return
                    
                }else{
                    return
                }
            }
            displayText += String(sender.tag)
            updateDisplay()
        }else{
            feedbackText = "Max operenad length reached! 😉"
            updateDisplay()
            }
        }
    }
    
    // change sign of operand - DONE
    @IBAction func changeSign(){
        if(displayText != "0"){
            if(displayText[displayText.startIndex] != "-"){
                displayText.insert("-", at: displayText.startIndex)
                updateDisplay()
            }else{
                displayText.remove(at: displayText.startIndex)
                updateDisplay()
            }
        }
    }
    
    // check the operation selected - DONE
    @IBAction func operation(_ sender: UIButton){
        // perfrom calculation using switch case
        if(sender.tag <= -2 && sender.tag >= -7){
            if(numb1Filled == false || numb2Filled == false){
                if(numb1Filled == false && operations == 0){
                    if(sender.tag != -2){
                        operations = sender.tag
                    }
                }
                fillOperands()
                if(numb2Filled != true){
                    return
                }
            }
            
            if(sender.tag != -2 && operations != 0){
                feedbackText = "One operation at a time! Please calculate with '=' or clear with 'C' . 😉"
                updateDisplay()
                return
            }
            
            if (sender.tag == -2 && operations != 0){
                switch operations {
                case (add):
                    additon(numb1, numb2)
                    break
                case (subtract):
                    subtraction(numb1, numb2)
                    break
                case (divide):
                    // check if numb2 is 0
                    if(numb2 == 0){
                        feedbackText = "Sorry, can't divide by Zero! 😟"
                        numb2Filled = false
                        updateDisplay()
                        return
                    }
                    divide(numb1, numb2)
                    break
                case (multiply):
                    multiply(numb1, numb2)
                    break
                case (mod):
                    if(numb2 == 0){
                        feedbackText = "Sorry, can't mod by Zero! 😟"
                        numb2Filled = false
                        updateDisplay()
                        return
                    }
                    mod(numb1, numb2)
                    break
                default: break
                }
            }
        }
    }
    
    // reset display - DONE
    @IBAction func clear(_ sender: UIButton) {
        resetOperands()
        displayText = "0"
        decimalInOperand = false
        operations = 0
        feedbackText = "All operands cleared 😄"
        updateDisplay()
    }
    
    // fill operands - DONE
    func fillOperands(){
        if(numb1Filled == false){
            numb1 = Double(displayText) as! Double
            displayText = "0"
            updateDisplay()
            numb1Filled = true
            decimalInOperand = false
        }else{
            numb2 = Double(displayText) as! Double
            displayText = "0"
            updateDisplay()
            numb2Filled = true
            decimalInOperand = false
        }
    }
    
    // reset operands values - DONE
    func resetOperands(){
        numb1 = 0.0
        numb2 = 0.0
        operations = 0
        numb2Filled = false
        numb1Filled = false
    }
    
    // math operations
    // addition - DONE
    func additon(_ a: Double, _ b: Double){
        feedbackText = "\(a) + \(b) = "
        displayText = String(a + b)
        updateDisplay()
        resetOperands()
    }
    
    // subtraction - DONE
    func subtraction(_ a: Double, _ b: Double){
        feedbackText = "\(a) - \(b) = "
        displayText = String(a - b)
        updateDisplay()
        resetOperands()
    }
    
    // multiply - DONE
    func multiply(_ a: Double, _ b: Double){
        feedbackText = "\(a) * \(b) = "
        displayText = String(a * b)
        updateDisplay()
        resetOperands()
    }
    
    // divide - DONE
    func divide(_ a: Double, _ b: Double){
        feedbackText = "\(a) / \(b) = "
        displayText = String(a / b)
        updateDisplay()
        resetOperands()
    }
    
    // mod - DONE
    func mod(_ a: Double, _ b: Double){
        feedbackText = "\(a) mod \(b) = "
        displayText = String(a.truncatingRemainder(dividingBy: b))
        updateDisplay()
        resetOperands()
    }

}
