//
//  WarehouseViewController.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import UIKit

protocol WarehouseChild {
    var controller : UIViewController { get }
    var screenTitle: String { get }
    
    func setQuery(mode: FilterMode)
}

class WarehouseViewController: SegmentedViewController {
    
    private var barButton: UIBarButtonItem?
    var controllers = [WarehouseChild]()
    
    init() {
        self.controllers = [ProductsTableViewController(), ProductGroupsTableViewController()]
        super.init(titlesAndControllers: [[controllers[0].screenTitle: controllers[0].controller], [controllers[1].screenTitle: controllers[1].controller]])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Warehouse"
        segmentedControl.tintColor = UIColor.black
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(self.filterProducts))
    }
    
    @objc private func filterProducts() {
        let actionSheet = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Show products price 0", style: .default, handler: { (alertAction) in
            self.controllers[self.selectedViewControllerIndex].setQuery(mode: .Filtered)
        }))
        actionSheet.addAction(UIAlertAction(title: "Show all products", style: .default, handler: { (alertAction) in
            self.controllers[self.selectedViewControllerIndex].setQuery(mode: .All)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}
