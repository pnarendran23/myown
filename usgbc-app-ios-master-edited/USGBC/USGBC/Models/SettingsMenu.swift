//
//  QuickMenu.swift
//  USGBC
//
//  Created by Vishal Raj on 29/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsMenu: Object {
    var sectionName = ""
    var sectionList = List<SettingsSubMenu>()
}
