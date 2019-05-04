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
    
    let posNeg = -8
    let mod = -7
    let divide = -6
    let multiply = -5
    let subtract = -4
    let add = -3
    let equals = -2
    let dot = -1
    
    var numb1Filled: Bool = false
    var numb2Filled: Bool = false
    
    
    // Holds solutions to calculations
    var answer: Double = 0.0
    // Holds first operand
    var numb1 = 0.0
    // Holds second operand
    var numb2 = 0.0
    
    // Shows on the screen
    var displayText: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // updates the display view
    func updateDisplay(){
        display.text = displayText
    }
    
    // check the number pressed
    @IBAction func numPress(sender: UIButton){
        if (sender.tag >= 0 && sender.tag <= 9){
            if(displayText == "0"){
                displayText = ""
            }
            displayText += String(sender.tag)
            updateDisplay()
        }
    }
    
    // check the operation pressed
    @IBAction func operation(_ sender: UIButton){
        if(numb1Filled == false || numb2Filled == false){
            fillOperands()
            return
        }
        
        // perfrom calculation using switch case
        if(sender.tag <= -2 && sender.tag >= -7){
            
        }
    }
    
    // reset display
    @IBAction func clear(_ sender: UIButton) {
        answer = 0.0
        displayText = "0"
        updateDisplay()
    }
    
    // fill operands
    func fillOperands(){
        if(numb1Filled == false){
            numb1 = Double(displayText) as! Double
            displayText = "0"
            updateDisplay()
            numb1Filled = true
        }
        
        if(numb2Filled == false && numb1Filled == true){
            numb2 = Double(displayText) as! Double
            displayText = "0"
            updateDisplay()
            numb2Filled = true
        }
    }
    
    // reset operands values
    func resetOperands(){
        numb2Filled = false
        numb1Filled = false
    }
    
    // math operations
    // addition
    func additon(_ a: Double, _ b: Double){
        displayText = String(a + b)
        updateDisplay()
    }
    
    // subtraction
    func subtraction(_ a: Double, _ b: Double){
        displayText = String(a - b)
        updateDisplay()
    }
    
    // multiply
    func multiply(_ a: Double, _ b: Double){
        displayText = String(a * b)
        updateDisplay()
    }
    
    // divide
    func divide(_ a: Double, _ b: Double){
        displayText = String(a / b)
        updateDisplay()
    }

}

