//
//  ResourcesLeedFilter.swift
//  USGBC
//
//  Created by Vishal Raj on 24/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import RealmSwift

class ResourcesLeedFilter: Object{
    dynamic var name = ""
    var subFilters = List<ResourcesLeedSubFilter>()
}
