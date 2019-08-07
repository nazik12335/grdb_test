//
//  ProductDetailsTableViewController.swift
//  GRDB_Test
//
//  Created by Nazar on 8/1/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import UIKit

class ProductDetailsTableViewController: UITableViewController {
    
    private enum State {
        case Normal
        case Editing
    }
    
    private var product: Product
    private var barButton: UIBarButtonItem?
    private var state: State = .Normal
    private var productService = ProductService()
    private let detailsCell: DetailsTableViewCell = {
        return UINib(nibName: "DetailsTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DetailsTableViewCell
    }()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        barButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editMode))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "DetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        detailsCell.setupCell(product: product)
    }
    
    @objc private func editMode() {
        switch state {
        case .Normal:
            state = .Editing
            detailsCell.activateTextField()
            barButton?.title = "Save"
        case .Editing:
            state = .Normal
            detailsCell.deactivateTextField()
            barButton?.title = "Edit"
            updateProductName()
        }
    }
    
    private func updateProductName() {
        productService.updateProductName(id: Int(product.id), name: detailsCell.nameTextField.text!, successHandler: { [weak self] in
                self?.product.name = self?.detailsCell.nameTextField.text ?? ""
                if let product = self?.product {
                self?.detailsCell.setupCell(product: product)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension ProductDetailsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return detailsCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
