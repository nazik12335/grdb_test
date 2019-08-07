//
//  Request.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation

protocol Request {
    associatedtype ResultType
    var range: NSRange { get set }
    var modelType: ModelType { get set }
    var condition: [String:AnyObject] { get set }
    var sorted: SortedBy { get set}
}

struct Sorted {
    var key: String
    var ascending: Bool = true
}

enum SortedBy {
    case none
    case condition(Sorted)
    
    init(_ value: Sorted) {
        self = .condition(value)
    }
    
    init() {
        self = .none
    }
}

enum ModelType {
    case product
    case productGroup
}
