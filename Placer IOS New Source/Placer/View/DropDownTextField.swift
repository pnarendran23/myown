//
//  DropDownTextField.swift
//  Placer
//
//  Created by Vishal on 06/09/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class DropDownTextField: UITextField {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)))
    }
}

