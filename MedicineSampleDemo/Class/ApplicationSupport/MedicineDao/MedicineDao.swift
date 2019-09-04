//
//  MedicineDao.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 04/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import Foundation
import UIKit

class MedicineDao {
    
    static let shared = MedicineDao()
    //Initializer access level change now
    private init(){}
    
    func showToast(message: String) {
        let title = UILabel.init(frame: CGRect.init(x: 10.0, y: UIScreen.main.bounds.size.height - 100.0, width: UIScreen.main.bounds.size.width - 20.0, height: 44.0))
        title.backgroundColor = UIColor.black
        title.textColor = UIColor.white
        title.numberOfLines = 2
        title.alpha = 0.8
        title.layer.borderWidth         = 0.8;
        title.layer.cornerRadius        = 4.0;
        title.layer.masksToBounds       = true
        title.textAlignment = .center
        title.text = message
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(title)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            title.removeFromSuperview()
        }
    }
    
    /**
     Simple Alert
     - Show alert with title and alert message and basic two actions
     */
    func showErrorAlert(title: String, message: String, obj: UIViewController) {
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        obj.present(alert, animated: true, completion: nil)
    }
    
    func showLoader(obj: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        obj.present(alert, animated: true, completion: nil)
    }
    
    func hideLoader(obj: UIViewController) {
        obj.dismiss(animated: false, completion: nil)
    }
}
