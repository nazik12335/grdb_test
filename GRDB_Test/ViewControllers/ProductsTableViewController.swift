//
//  ViewController.swift
//  GRDB_Test
//
//  Created by Nazar on 7/31/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import UIKit
import GRDB

enum FilterMode {
    case Filtered
    case All
}

class ProductsTableViewController: UITableViewController, WarehouseChild {
    var controller: UIViewController {
        return self
    }
    
    var screenTitle: String {
        return "Products"
    }
    
    func setQuery(mode: FilterMode) {
        self.switchFilter(filter: mode)
    }
    
    private var products: [Product] = []
    private var productFetchRange = NSMakeRange(0, 20)
    private var filteredFetchRange = NSMakeRange(0, 20)
    private var filter: FilterMode = .All
    private var productObserver: TransactionObserver?
    let productService = ProductService()
    var productDataSource: TableViewDataSource<Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //FIXIT: Global observer on db changes
    private func trackChanges(id: Int64) {
    let sqlLiteral = SQLLiteral(sql: "SELECT * FROM tblProducts WHERE \(Product.Columns.Product_Id.rawValue) = :id", arguments:  ["id": id])
    let request = SQLRequest<Row>(literal: sqlLiteral)
        productObserver = request.observationForFirst().start(in: dbQueue, onError: { (error) in
            print(error)
        }, onChange: { [weak self]  item in
            if let product = item {
                let productParser = ProductParser()
                if let product = productParser.parseArray(data: [product])!.first {
                    if let index = self?.products.index(where: {$0.id == product.id}) {
                        self?.products[index] = product
                        self?.setupProductsDataSource()
                    }
                }
            }
        })
    }
    
    private func setupProductsDataSource() {
        let dataSource = TableViewDataSource(models: products, reuseIdentifier: "Cell") { (product, cell) in
            cell.textLabel?.text = product.name
        }
        self.productDataSource = dataSource
        tableView.dataSource = self.productDataSource
    }

    private func getAllProducts() {
        productService.getProducts(range: productFetchRange, successHandler: {[weak self] (products) in
            self?.products.append(contentsOf: products)
            if products.count > 0 {
                self?.setupProductsDataSource()
                self?.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getSortedProducts() {
        productService.getFilteredProductsByPrice(price: 0.0, range: filteredFetchRange, successHandler: {[weak self] (products) in
            self?.products.append(contentsOf: products)
            if products.count > 0 {
                self?.setupProductsDataSource()
                self?.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getProducts() {
        switch filter {
        case .All:
            getAllProducts()
        case .Filtered:
            getSortedProducts()
        }
    }

    private func showFilteredProducts() {
        self.products.removeAll()
        self.tableView.reloadData()
        self.filteredFetchRange = NSMakeRange(0, 20)
        self.getProducts()
    }
    
    private func showAllProducts() {
        self.products.removeAll()
        self.tableView.reloadData()
        self.productFetchRange = NSMakeRange(0, 20)
        self.getProducts()
    }
    
    private func switchFilter(filter: FilterMode) {
        self.filter = filter
        switch filter {
        case .Filtered:
            showFilteredProducts()
        case .All:
            showAllProducts()
        }
    }
    
    @objc private func filterProducts() {
        let actionSheet = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Show products price 0", style: .default, handler: { (alertAction) in
            self.switchFilter(filter: .Filtered)
        }))
        actionSheet.addAction(UIAlertAction(title: "Show all products", style: .default, handler: { (alertAction) in
            self.switchFilter(filter: .All)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ProductsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackChanges(id: products[indexPath.row].id)
        let productVC = ProductDetailsTableViewController(product: products[indexPath.row])
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if(distanceFromBottom <= height * 2 && products.count >= Int(20)) {
                switch filter {
                case .Filtered:
                    filteredFetchRange = NSMakeRange(filteredFetchRange.location + 10, 10)
                    getProducts()
                case .All:
                    productFetchRange = NSMakeRange(productFetchRange.location + 10, 10)
                    getProducts()
                }
        }
    }
}
