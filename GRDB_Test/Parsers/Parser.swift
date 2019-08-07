//
//  Parser.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB

protocol Parser {
    associatedtype ResultType
    func parse(data: Row) -> ResultType?
    func parseArray(data: [Row]) -> [ResultType]?
}


class BaseParser<ParseResult>: Parser {
    typealias ResultType = ParseResult
    
    func parse(data: Row) -> ParseResult? {
        fatalError("Abstract method. Subclass BaseParser and override this method")
    }
    
    func parseArray(data: [Row]) -> [ParseResult]? {
        fatalError("Abstract method. Subclass BaseParser and override this method")
    }
}

