//
//  ProductService.swift
//  GRDB_Test
//
//  Created by Nazar on 8/5/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation

class ProductService {
    var storage: Storage
    init(storage: Storage = DBClient()) {
        self.storage = storage
    }
    
    func getProducts(range: NSRange, successHandler: @escaping ([Product]) -> (), errorHandler: @escaping (Error) -> ()) {
        let getProductsRequest = BaseRequest<Product>(range: range)
            storage.fetch(request: getProductsRequest) { (result) in
                switch result {
                case .success(let items):
                    successHandler(items)
                case .failure(let error):
                    errorHandler(error)
                }
        }
    }
    
    func getFilteredProductsByPrice( price: Double, range: NSRange, successHandler: @escaping ([Product]) -> (), errorHandler: @escaping (Error) -> ()) {
        let getProductsRequest = BaseRequest<Product>(range: range, condition: ["P_Price": price as AnyObject])
        storage.fetch(request: getProductsRequest) { (result) in
            switch result {
            case .success(let items):
                successHandler(items)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    func updateProductName(id: Int, name: String, successHandler: @escaping () -> (), errorHandler: @escaping (Error) -> ()) {
        let updateRequest = BaseRequest<Product>(condition: ["Product_Id": id as AnyObject, "ProductName" : name as AnyObject])
        storage.update(request: updateRequest) { error in
            if let dbError = error{
                errorHandler(dbError)
            }else {
                successHandler()
            }
        }
    }
}
