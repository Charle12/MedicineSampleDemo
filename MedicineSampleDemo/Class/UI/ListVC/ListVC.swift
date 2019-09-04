//
//  ViewController.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UIViewController {

   @IBOutlet weak var tableForListVc: UITableView!
   @IBOutlet weak var lblForNoRecord: UILabel!
   var viewModel = [ListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = constants.vcTitle.TITLE_MEDICINE_LIST
    }
    
    @IBAction func addMedicine(_ sender: UIBarButtonItem) {
        self.moveToAddMedicineInfoPage(nil)
    }
    
    fileprivate func showHideViewWhenThereISNoRecords(isShow: Bool) {
        self.lblForNoRecord.text = constants.message.NO_RECORDS
        self.lblForNoRecord.isHidden = isShow
        self.tableForListVc.isHidden = !isShow
    }
    
    fileprivate func fetchRecords() {
        weak var weakSelf = self
        CoreDataManager.sharedManager.fetchAllSavedInformationFromDB { (success, error, model) in
            if success, model.count > 0 {
                viewModel = model
                MedicineDao.shared.showToast(message: error)
                weakSelf?.showHideViewWhenThereISNoRecords(isShow: true)
            } else {
                MedicineDao.shared.showToast(message: constants.message.NO_RECORDS)
                weakSelf?.showHideViewWhenThereISNoRecords(isShow: false)
            }
        }
    }
    
    fileprivate func cloneData(model: ListModel) {
        weak var weakSelf = self
        CoreDataManager.sharedManager.saveMedicineInformationInEntity(medicineName: model.name ?? constants.EMPTY_STRING, medicineDescription: model.des ?? constants.EMPTY_STRING, price: String(format: "%.2f", model.price ?? 0.0), quantity: String(format: "%ld", model.quantity ?? 0)) { (flag, error, listModel) in
            if flag {
                weakSelf?.viewModel.append(model)
                weakSelf?.tableForListVc.beginUpdates()
                weakSelf?.tableForListVc.insertRows(at: [IndexPath(row: weakSelf!.viewModel.count - 1, section: 0)], with: .automatic)
                weakSelf?.tableForListVc.endUpdates()
            }
            MedicineDao.shared.showToast(message: constants.message.CLONE)
        }
    }
    fileprivate func deleteData(indexPath: IndexPath) {
        weak var weakSelf = self
        CoreDataManager.sharedManager.deleteData(medicineName: self.viewModel[indexPath.row].name ?? constants.EMPTY_STRING) { (flag, error, listModel) in
            if flag {
                weakSelf?.viewModel.remove(at: indexPath.row)
                weakSelf?.tableForListVc.beginUpdates()
                weakSelf?.tableForListVc.deleteRows(at: [indexPath], with: .automatic)
                weakSelf?.tableForListVc.endUpdates()
                if weakSelf?.viewModel.count == 0 {
                    weakSelf?.showHideViewWhenThereISNoRecords(isShow: false)
                }
            }
            MedicineDao.shared.showToast(message: error)
        }
    }
}

extension ListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListTVC = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as! ListTVC
        cell.selectionStyle = .none
        if self.viewModel.count > 0 {
            let cellViewModel = viewModel[indexPath.row]
            cell.viewModel = cellViewModel
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
    
    fileprivate func moveToAddMedicineInfoPage(_ indexPath: IndexPath?) {
        // update item at indexPath
        let addMedicineDetailVC = self.storyboard!.instantiateViewController(withIdentifier: constants.vc.VC_ADD_MEDICINE_DETAIL) as! AddMedicineDetailVC
        addMedicineDetailVC.delegate = self
        if let indexPath = indexPath {
            addMedicineDetailVC.index = indexPath.row
            addMedicineDetailVC.listModel = self.viewModel[indexPath.row]
        }
        self.navigationController!.pushViewController(addMedicineDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: constants.ACTION_DELETE) { (action, indexPath) in
            // delete item at indexPath
            self.deleteData(indexPath: indexPath)
        }
        let clone = UITableViewRowAction(style: .destructive, title: constants.ACTION_CLONE) { (action, indexPath) in
            // clone item at indexPath
            self.cloneData(model: self.viewModel[indexPath.row])
        }
        let edit = UITableViewRowAction(style: .normal, title: constants.ACTION_EDIT) { (action, indexPath) in
            // edit item at indexPath
            self.moveToAddMedicineInfoPage(indexPath)
        }
        clone.backgroundColor = UIColor.blue
        return [delete, clone, edit]
    }
}

extension ListVC : AddMedicineDetailVCDelegate {
    func updateInfoModel(model: ListModel, isUpdate: Bool, index: Int) {
        if isUpdate, index >= 0 {
            self.viewModel[index] = model
            self.tableForListVc.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            self.showHideViewWhenThereISNoRecords(isShow: true)
            self.viewModel.append(model)
            self.tableForListVc.beginUpdates()
            self.tableForListVc.insertRows(at: [IndexPath(row: self.viewModel.count - 1, section: 0)], with: .automatic)
            self.tableForListVc.endUpdates()
        }
    }
}

