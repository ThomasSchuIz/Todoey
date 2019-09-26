//
//  Item.swift
//  Todoey
//
//  Created by Thomas Schulz on 9/26/19.
//  Copyright © 2019 Thomas Schulz. All rights reserved.
//

import Foundation

// Classes that are encodable & decodable (Codeable together) MUST have standard data types
// No custom data types
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
