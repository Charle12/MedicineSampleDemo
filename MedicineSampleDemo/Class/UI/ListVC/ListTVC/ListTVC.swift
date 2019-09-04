//
//  ListTVC.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import UIKit

class ListTVC: UITableViewCell {
    
    @IBOutlet weak var lblForMedicineName: UILabel!
    @IBOutlet weak var lblForMedicinePrice: UILabel!
    @IBOutlet weak var lblForMedicineQuantity: UILabel!
    @IBOutlet weak var lblForMedicineDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public var viewModel: ListModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.lblForMedicineName.text = viewModel.name
            self.lblForMedicinePrice.attributedText = Utility.createAttributedText(fullStr: String(format: "Price: %.2f", viewModel.price ?? 0.0), toColor: "Price", colour: UIColor.black)
            self.lblForMedicineQuantity.attributedText = Utility.createAttributedText(fullStr: String(format: "Quantity: %ld", viewModel.quantity ?? 0), toColor: "Quantity", colour: UIColor.black)
            self.lblForMedicineDescription.text = viewModel.des
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
