//
//  CircleEdgeLabel.swift
//  calc
//
//  Created by Uchechukwu Uboh on 5/4/19.
//  Copyright © 2019 Uchechukwu Uboh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircleEdgeLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 30.0{
        didSet{
            setUpView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView(){
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
