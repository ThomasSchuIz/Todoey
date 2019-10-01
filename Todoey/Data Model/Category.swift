//
//  Category.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/30/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    // Defines the forward relationship between category and item
    let items = List<Item>()
}
