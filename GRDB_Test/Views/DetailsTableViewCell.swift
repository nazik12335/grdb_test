//
//  DetailsTableViewCell.swift
//  GRDB_Test
//
//  Created by Nazar on 8/2/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    private var product: Product!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(product: Product) {
        nameTextField.text = product.name
        self.product = product
        infoTextView.text = productInfo()
    }
    
    func activateTextField() {
        nameTextField.isEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
    func deactivateTextField() {
        nameTextField.isEnabled = false
    }
    
    private func productInfo() -> String {
        let name = "name: \(product.name)\n"
        let id = "id: \(product.id)\n"
        let typeId = "typeId: \(product.typeId)\n"
        let groupId = "groupId: \(product.groupId)\n"
        let categoryId = "categoryId: \(product.categoryId)\n"
        let productShortName = "productShortName: \(product.productShortName)\n"
        let unitId = "unitId: \(product.unitId)\n"
        let unitWeight = "unitWeight: \(product.unitWeight)\n"
        let status = "status: \(product.status)\n"
        let sortOrder = "sortOrder: \(product.sortOrder)\n"
        let price = "price: \(product.price)\n"
        let packageQty = "packageQty: \(product.packageQty)\n"
        let tarePackQty = "tarePackQty: \(product.tarePackQty)\n"
        let isProductWeight = "isProductWeight: \(product.isProductWeight)\n"
        let code = "code: \(product.code)\n"

        return name + id + typeId + groupId + categoryId + productShortName + unitId + unitWeight + status + sortOrder + price + packageQty + tarePackQty + isProductWeight + code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
