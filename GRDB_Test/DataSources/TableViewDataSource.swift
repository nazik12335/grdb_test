//
//  TableViewDataSource.swift
//  GRDB_Test
//
//  Created by Nazar on 8/6/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> ()
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cellConfigurator(model, cell)
        return cell
    }
}
