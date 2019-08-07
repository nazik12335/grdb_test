//
//  ParserFactory.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation

class ParserFactory {
    private var factories: [String: () -> Any] = [:]
    
    init() {
        register(BaseParser<ProductGroup>.self, ProductGroupParser())
        register(BaseParser<Product>.self, ProductParser())
    }
    
    func createParser<T>() -> BaseParser<T>? {
        let key = String(describing: BaseParser<T>.self)
        return factories[key]?() as? BaseParser<T>
    }
    
    private func register<T>(_ type: T.Type, _ factory: @autoclosure @escaping () -> T) {
        factories[String(describing: type)] = factory
    }
}
