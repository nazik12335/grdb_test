//
//  ProductsRepository.swift
//  GRDB_Test
//
//  Created by Nazar on 8/2/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB

enum Result<T, E: Error>{
    case success(T)
    case failure(E)
}

protocol Storage{
    func fetch<T:Request>(request: T, handler:@escaping (Result<[T.ResultType],NSError>) -> ())
    func update<T: Request>(request: T, handler:@escaping (NSError?)->())
}
