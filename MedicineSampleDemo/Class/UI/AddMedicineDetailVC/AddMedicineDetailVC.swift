//
//  AddMedicineDetailVC.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import UIKit

protocol AddMedicineDetailVCDelegate {
    func updateInfoModel(model: ListModel, isUpdate: Bool, index: Int)
}

class AddMedicineDetailVC: UIViewController {
    var delegate: AddMedicineDetailVCDelegate?
    @IBOutlet weak var tableForAddDetailVc: UITableView!
    var viewModel = [AddressModel]()
    var listModel: ListModel?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.namemakeAddressArray()
        if listModel != nil {
            if let name = listModel?.name {
                self.updateValueInArray(index: 0, val1: name)
            }
            if let price = listModel?.price {
                self.updateValueInArray(index: 1, val1: String(format: "%.2f", price))
            }
            if let quantity = listModel?.quantity {
                self.updateValueInArray(index: 2, val1: String(format: "%ld", quantity))
            }
            if let des = listModel?.des {
                self.updateValueInArray(index: 3, val1: des)
            }
        }
    }
    
    fileprivate func namemakeAddressArray() {
        var json: [Any]? = nil
        do {
            if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "AddJsonStub", ofType: "json") ?? "") {
                json = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [Any]
            }
        } catch {
        }
        for item in json! {
            viewModel.append(AddressModel.init(dict: item as! [String : Any]))
        }
    }
    
    func updateValueInArray(index: Int, val1: String) {
        let item = viewModel[index]
        item.txt1 = val1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = constants.vcTitle.TITLE_MEDICINE_DETAIL
        
    }
    
    fileprivate func checkValidationWhileSavingAddress() -> Bool {
        var isAllTrue: Bool = true
        for item in viewModel {
            if ((item.txt1 ?? constants.EMPTY_STRING).count > 0 && (item.tag == 0 || item.tag == 1  || item.tag == 2 || item.tag == 3)) {
                item.showError = true
            } else {
                item.showError = false
                isAllTrue = false
            }
        }
        return isAllTrue
    }

    func returnTxtValue(index: Int) -> String {
        return viewModel[index].txt1 ?? constants.EMPTY_STRING
    }
    
    @IBAction func addMedicineInformation(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if self.checkValidationWhileSavingAddress() == true {
            if listModel != nil {
                self.updateData()
            } else {
                self.saveData()
            }
        } else {
            self.tableForAddDetailVc.reloadData()
        }
    }
    
    fileprivate func saveData() {
        weak var weakSelf = self
        CoreDataManager.sharedManager.saveMedicineInformationInEntity(medicineName: self.returnTxtValue(index: 0), medicineDescription: self.returnTxtValue(index: 3), price: self.returnTxtValue(index: 1), quantity: self.returnTxtValue(index: 2)) { (flag, error, listModel) in
            if flag {
                if let objectModel = listModel.first {
                    weakSelf?.delegate?.updateInfoModel(model: objectModel, isUpdate: true, index: -1)
                }
                weakSelf?.navigationController?.popViewController(animated: true)
            }
            MedicineDao.shared.showToast(message: error)
        }
    }

    fileprivate func updateData() {
        weak var weakSelf = self
        CoreDataManager.sharedManager.updateMedicineInformationInEntity(medicineName: listModel?.name ?? constants.EMPTY_STRING, updatedMedicineName: self.returnTxtValue(index: 0), updatedMedicineDescription: self.returnTxtValue(index: 3), updatedPrice: self.returnTxtValue(index: 1), updatedQuantity: self.returnTxtValue(index: 2)) { (flag, error, listModel) in
            if flag {
                if let objectModel = listModel.first {
                    weakSelf?.delegate?.updateInfoModel(model: objectModel, isUpdate: true, index: weakSelf?.index ?? -1)
                }
                weakSelf?.navigationController?.popViewController(animated: true)
            }
            MedicineDao.shared.showToast(message: error)
        }
    }
}

extension AddMedicineDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AddDetailTVC = tableView.dequeueReusableCell(withIdentifier: AddDetailTVC.identifier, for: indexPath) as! AddDetailTVC
        cell.selectionStyle = .none
        if self.viewModel.count > 0 {
            let cellViewModel = viewModel[indexPath.section]
            cell.addressModel = cellViewModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

