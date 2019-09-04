//
//  ListModel.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 04/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import UIKit

class ListModel: NSObject {
    
    var name:String?
    var des: String?
    var quantity:Int64?
    var price:Double?
    
    init (dict:[String: Any]) {
        if let name = dict[constants.dbKey.KEY_NAME] as? String {
            self.name = name
        } else {
            self.name = constants.EMPTY_STRING
        }
        if let des = dict[constants.dbKey.KEY_DESCRIPTION] as? String {
            self.des = des
        } else {
            self.des = constants.EMPTY_STRING
        }
        if let quantity = dict[constants.dbKey.KEY_QUANTITY] as? Int64 {
            self.quantity = quantity
        } else {
            self.quantity = 0
        }
        if let price = dict[constants.dbKey.KEY_PRICE] as? Double {
            self.price = price
        } else {
            self.price = 0.0
        }
    }
}
