//
//  ProductTypeService.swift
//  GRDB_Test
//
//  Created by Nazar on 8/5/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation

class ProductGroupsService {
    private var storage: Storage
    
    init(storage: Storage = DBClient()) {
        self.storage = storage
    }
    
    func getProductGroups(range: NSRange, successHandler: @escaping ([ProductGroup]) -> (), errorHandler: @escaping (Error) -> ()) {
        let getProductGroups = BaseRequest<ProductGroup>(range: range, modelType: .productGroup)
        storage.fetch(request: getProductGroups) { (result) in
            switch result {
            case .success(let items):
                successHandler(items)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}


