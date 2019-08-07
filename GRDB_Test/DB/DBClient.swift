//
//  DataBase.swift
//  GRDB_Test
//
//  Created by Nazar on 8/1/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import GRDB

final class DBClient: Storage {
    
    let parserFactory = ParserFactory()
    private let queue = DispatchQueue.global(qos: .background)

    class func openDatabase(path: String) throws -> DatabaseQueue {
        let dbQueue = try DatabaseQueue(path: path)
        return dbQueue
    }
    
    func fetch<T>(request: T, handler:@escaping (Result<[T.ResultType],NSError>) -> ()) where T: Request {
        
        let allProductsRequest = SQLRequest<Row>(literal: request.toSelectSQL())
        queue.async {
            do {
                try dbQueue.read { db in
                    let rows = try Row.fetchAll(db, allProductsRequest)
                    
                    guard let parser: BaseParser<T.ResultType> = self.parserFactory.createParser() else {
                        let error = NSError(domain: "Missed parser error", code: 404, userInfo: nil)
                        handler(.failure(error))
                        return
                    }
                    
                    guard let value = parser.parseArray(data: rows) else {
                        let error = NSError(domain: "Parsing error", code: 404, userInfo: nil)
                        handler(.failure(error))
                        return
                    }
                    DispatchQueue.main.async {
                        handler(.success(value))
                    }
                }
            }catch let error as DatabaseError {
                DispatchQueue.main.async {
                    let bridgedError = NSError(domain: DatabaseError.errorDomain, code: error.errorCode, userInfo: error.errorUserInfo)
                    handler(.failure(bridgedError))
                }
            } catch {
                let error = NSError(domain: "Select records database error", code: 404, userInfo: nil)
                DispatchQueue.main.async {
                    handler(.failure(error))

                }
            }
        }
    }
    
    func update<T>(request: T, handler: @escaping (NSError?) -> ()) where T : Request {
        
        let sqlLiteral = request.toUpdateSQL()
        queue.async {
            do {
                try dbQueue.write{ db in
                    try db.execute(literal: sqlLiteral)
                    DispatchQueue.main.async {
                        handler(nil)
                    }
                }
            } catch let error as DatabaseError {
                DispatchQueue.main.async {
                    let bridgedError = NSError(domain: DatabaseError.errorDomain, code: error.errorCode, userInfo: error.errorUserInfo)
                    handler(bridgedError)
                }
            } catch {
                let error = NSError(domain: "Database update error", code: 404, userInfo: nil)
                DispatchQueue.main.async {
                    handler(error)
                }
            }
        }
    }
}

extension Request {
    func toSelectSQL() -> SQLLiteral{
        var sqlLiteral = SQLLiteral(sql: "SELECT * FROM \(ResultType.entityName) ")
        sqlLiteral.append(literal: condition())
        sqlLiteral.append(sql: "LIMIT \(self.range.length) OFFSET \(self.range.location)")
        return sqlLiteral
    }
    
    func toUpdateSQL() -> SQLLiteral{
        var sqlLiteral = SQLLiteral(sql: "UPDATE \(ResultType.entityName) ")
        sqlLiteral.append(literal: set())
        return sqlLiteral
    }
    
    private func set() -> SQLLiteral {
        guard self.values.keys.count > 0 && self.condition.keys.count == 1 else {return SQLLiteral(sql: "")}
        var setLiteral: SQLLiteral?
    
        for item in self.values {
            if setLiteral == nil {
                setLiteral = SQLLiteral(sql: "SET \(item.key) = ? ", arguments: [DatabaseValue(value: item.value)])
            }else {
                let literal = SQLLiteral(sql: "\(item.key) = ? ", arguments: [DatabaseValue(value: item.value)])
                setLiteral?.append(literal: literal)
            }
        }
        setLiteral?.append(literal: condition())
        
        return setLiteral!
    }
    
    private func condition() -> SQLLiteral {
        guard self.condition.keys.count > 0 else {return SQLLiteral(sql: "")}
        var conditionLiteral: SQLLiteral?
        for item in self.condition {
            if conditionLiteral == nil {
                conditionLiteral = SQLLiteral(sql: "WHERE \(item.key) = ? ", arguments: [DatabaseValue(value: item.value)])
            }else {
                let literal = SQLLiteral(sql: "AND \(item.key) = ? ", arguments: [DatabaseValue(value: item.value)])
                conditionLiteral?.append(literal: literal)
            }
        }
        return conditionLiteral!
    }
}

protocol EntityNameHolder {
    static var entityName: String { get }
}

extension Product: EntityNameHolder {
    static var entityName: String {
        return "tblProducts"
    }
}

extension ProductGroup: EntityNameHolder {
    static var entityName: String {
        return "tblProductGroups"
    }
}
