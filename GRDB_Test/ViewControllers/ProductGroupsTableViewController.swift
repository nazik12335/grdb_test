//
//  ProductGroupsTableViewController.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import UIKit

class ProductGroupsTableViewController: UITableViewController, WarehouseChild {
    var controller: UIViewController {
        return self
    }
    
    var screenTitle: String {
        return "Product Groups"
    }
    
    func setQuery(mode: FilterMode) {
        let alert = UIAlertController(title: "Filtering is not available.", message: nil, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    private var productGroups: [ProductGroup] = []
    private var productGroupFetchRange = NSMakeRange(0, 20)
    
    let productGroupService = ProductGroupsService()
    var productGroupDataSource: TableViewDataSource<ProductGroup>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllProductGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProductGroupsDataSource() {
        let dataSource = TableViewDataSource(models: productGroups, reuseIdentifier: "Cell") { (product, cell) in
            cell.textLabel?.text = product.name
        }
        self.productGroupDataSource = dataSource
        tableView.dataSource = self.productGroupDataSource
    }
    
    private func getAllProductGroups() {
        productGroupService.getProductGroups(range: productGroupFetchRange, successHandler: { (productGroups) in
            self.productGroups.append(contentsOf: productGroups)
            if productGroups.count > 0 {
                self.setupProductGroupsDataSource()
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension ProductGroupsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if(distanceFromBottom <= height * 2 && productGroups.count >= Int(20)) {
            productGroupFetchRange = NSMakeRange(productGroupFetchRange.location + 10, 10)
            getAllProductGroups()
        }
    }
}
