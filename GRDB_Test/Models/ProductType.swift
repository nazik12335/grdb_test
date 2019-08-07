//
//  ProductType.swift
//  GRDB_Test
//
//  Created by Nazar on 8/5/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation

class ProductGroup {
    var id: Int64 = 0
    var name: String = ""
    var shortName: String = ""
    var categoryId: Int = 0
    
    init(id: Int64, name: String, shortName: String, categoryId: Int) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.categoryId = categoryId
    }
}
