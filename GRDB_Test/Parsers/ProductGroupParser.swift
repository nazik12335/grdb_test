//
//  ProductTypeParser.swift
//  GRDB_Test
//
//  Created by Nazar on 8/5/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB
class ProductGroupParser: BaseParser<ProductGroup> {
    override func parseArray(data: [Row]) -> [ProductGroup]? {
        let products: [ProductGroup] = data.map { row in
            return ProductGroup(id: row["ProdGroup_Id"],
                           name: row["ProdGroupName"],
                           shortName: row["ProdGroupShortName"],
                           categoryId: row["ProdCategory_Id"])
        }
        return products
    }
}
