//
//  CourseFilter.swift
//  USGBC
//
//  Created by Vishal Raj on 21/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import RealmSwift

class CourseFilter: Object{
    dynamic var name = ""
    var subFilters = List<CourseSubFilter>()
}
