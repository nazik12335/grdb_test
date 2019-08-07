//
//  Product.swift
//  GRDB_Test
//
//  Created by Nazar on 8/1/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB

class Product: CustomStringConvertible{
    var id: Int64 = 0
    var typeId: Int = 0
    var groupId: Int = 0
    var categoryId: Int = 0
    var productShortName: String = ""
    var unitId: Int = 0
    var unitWeight: Double = 0.0
    var status: Int8 = 0
    var sortOrder: Int = 0
    var price: Double = 0.0
    var packageQty: Double = 0.0
    var tarePackQty: Double = 0.0
    var isProductWeight: Bool = false
    var code: String = ""
    var name: String = ""

    init(id: Int64,
         typeId: Int,
         groupId: Int,
         categoryId: Int,
         productShortName: String,
         unitId: Int,
         unitWeight: Double,
         status: Int8,
         sortOrder: Int,
         price: Double,
         packageQty: Double,
         tarePackQty: Double,
         isProductWeight: Bool,
         code: String,
         name: String) {
        self.id = id
        self.typeId = typeId
        self.groupId = groupId
        self.categoryId = categoryId
        self.productShortName = productShortName
        self.unitId = unitId
        self.unitWeight = unitWeight
        self.status = status
        self.sortOrder = sortOrder
        self.price = price
        self.packageQty = packageQty
        self.tarePackQty = tarePackQty
        self.isProductWeight = isProductWeight
        self.code = code
        self.name = name
    }
    
    enum Columns: String {
        case Product_Id, ProductType_Id, ProdGroup_Id, ProdCategory_Id, ProductShortName, Unit_Id, UnitWeight, Status, PP_SortOrder, P_Price, Package_qty, TarePack_Qty, IsProductWeight, ProductCode, ProductName
    }

    var description: String {
        return "\(name) price is: \(price)"
    }
}

