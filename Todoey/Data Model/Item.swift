//
//  Item.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/30/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    // This creates the inverse relationship that points back from item to Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
