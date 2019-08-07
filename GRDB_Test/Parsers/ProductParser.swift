//
//  ProductParser.swift
//  GRDB_Test
//
//  Created by Nazar on 8/1/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB

class ProductParser: BaseParser<Product> {
    override func parseArray(data: [Row]) -> [Product]? {
        let products: [Product] = data.map { row in
            return Product(id: row["Product_Id"],
                           typeId: row["ProductType_Id"],
                           groupId: row["ProdGroup_Id"],
                           categoryId: row["ProdCategory_Id"],
                           productShortName: row["ProductShortName"],
                           unitId: row["Unit_Id"],
                           unitWeight: row["UnitWeight"],
                           status: row["Status"],
                           sortOrder: row["PP_SortOrder"],
                           price: row["P_Price"],
                           packageQty: row["Package_qty"],
                           tarePackQty: row["TarePack_Qty"],
                           isProductWeight: row["IsProductWeight"],
                           code: row["ProductCode"],
                           name: row["ProductName"])
        }
        return products
    }
}
