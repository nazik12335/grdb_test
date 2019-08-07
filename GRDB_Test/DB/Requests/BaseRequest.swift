//
//  BaseRequest.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation


class BaseRequest<T: EntityNameHolder>: Request {
    typealias ResultType = T
    var range: NSRange
    var condition: [String:AnyObject]
    var values: [String:AnyObject]
    var sorted: SortedBy
    
    init(range: NSRange = NSMakeRange(0, 0), condition: [String:AnyObject] = [:], values: [String:AnyObject] = [:], sorted: SortedBy = SortedBy()) {
        self.range = range
        self.condition = condition
        self.values = values
        self.sorted = sorted
    }
}
