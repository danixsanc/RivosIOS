//
//  MyTextField.swift
//  RivosTaxi
//
//  Created by Alejandro Rios on 15/01/16.
//  Copyright © 2016 Yozzi Been's. All rights reserved.
//

import UIKit
class MyTextField: UITextField {
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
        let border = CALayer()
        let width = CGFloat(1.0)
        
        border.borderColor = UIColor.lightGrayColor().CGColor
        
        
        border.frame = CGRect(x: 1, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        
    }
}
