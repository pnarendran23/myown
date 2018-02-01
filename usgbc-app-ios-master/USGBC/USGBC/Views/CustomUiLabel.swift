//
//  CustomUiLabel.swift
//  USGBC
//
//  Created by Vishal Raj on 19/06/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CustomUiLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    }
}
