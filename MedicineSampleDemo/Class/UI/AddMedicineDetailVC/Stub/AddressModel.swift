//
//  AddressModel.swift
//  CARS24Dealer
//
//  Created by CharlePrabhat on 20/06/19.
//  Copyright © 2019 Cars24. All rights reserved.
//

import UIKit

struct AddressModelConstatnt {
    
    static let KEY_PLACE_HOLDER                  = "placeHolder"
    static let KEY_TEXT1                         = "txt1"
    static let KEY_LBL_TITLE                     = "lblTitle"
    static let KEY_TAG                           = "tag"
    static let KEY_SHOW_ERROR                    = "showError"
    static let KEY_ERROR_MSG                     = "errorMsg"
}

class AddressModel: NSObject {
    
    var placeHolder: String?
    var txt1: String?
    var lblTitle: String?
    var tag: Int?
    var showError: Bool?
    var errorMsg: String?
    
    init (dict:[String: Any]) {
        if let errorMsg = dict[AddressModelConstatnt.KEY_ERROR_MSG] as? String {
            self.errorMsg = errorMsg
        } else {
            self.errorMsg = constants.EMPTY_STRING
        }
        if let placeHolder = dict[AddressModelConstatnt.KEY_PLACE_HOLDER] as? String {
            self.placeHolder = placeHolder
        } else {
            self.placeHolder = constants.EMPTY_STRING
        }
        if let txt1 = dict[AddressModelConstatnt.KEY_TEXT1] as? String {
            self.txt1 = txt1
        } else {
            self.txt1 = constants.EMPTY_STRING
        }
        if let lblTitle = dict[AddressModelConstatnt.KEY_LBL_TITLE] as? String {
            self.lblTitle = lblTitle
        } else {
            self.lblTitle = constants.EMPTY_STRING
        }
        if let tag = dict[AddressModelConstatnt.KEY_TAG] as? Int {
            self.tag = tag
        } else {
            self.tag = 0
        }
        if let showError = dict[AddressModelConstatnt.KEY_SHOW_ERROR] as? Bool {
            self.showError = showError
        } else {
            self.showError = false
        }
    }
}
