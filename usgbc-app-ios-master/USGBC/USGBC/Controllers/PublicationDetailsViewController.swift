//
//  PublicationDetailsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 13/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import PSPDFKit

class PublicationDetailsViewController: PSPDFViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.thumbnailController.stickyHeaderEnabled = true        
        self.thumbnailController.filterSegment.tintColor = UIColor.hex(hex: Colors.primaryColor)
    }
    
    
    
    
}
