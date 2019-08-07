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
    var condition: [String:AnyObject]
    var range: NSRange
    var sorted: SortedBy
    
    init(range: NSRange = NSMakeRange(0, 0), condition: [String:AnyObject] = [:], sorted: SortedBy = SortedBy()) {
        self.range = range
        self.condition = condition
        self.sorted = sorted
    }
}
