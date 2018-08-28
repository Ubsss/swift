//
//  circleButton.swift
//  scribeSpeechToText
//
//  Created by Uchechukwu Uboh on 8/25/18.
//  Copyright © 2018 Uchechukwu Uboh. All rights reserved.
//

import UIKit

@IBDesignable
class circleButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet{
            setUpView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView(){
        layer.cornerRadius = cornerRadius
    }
    
}
