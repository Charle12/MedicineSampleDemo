//
//  Constant.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.

import Foundation

struct constants {
    static let EMPTY_STRING  = ""
    static let APP_NAME      = "MedicineSampleDemo"
    static let ACTION_DELETE = "Delete"
    static let ACTION_CLONE  = "Clone"
    static let ACTION_EDIT   = "Edit"
    
    struct coreDataStack {
        static let DATABASE_NAME = "MedicineSampleDemo"
        static let TABLE_NAME = "Medicine"
    }
    
    struct vcTitle {
        static let TITLE_MEDICINE_LIST   = "Medicine List"
        static let TITLE_MEDICINE_DETAIL = "Add Medicine Detail"
    }

    struct vc {
        static let VC_ADD_MEDICINE_DETAIL = "AddMedicineDetailVC"
    }
    
    struct dbKey {
        static let KEY_NAME        = "medicineName"
        static let KEY_DESCRIPTION = "medicineDescription"
        static let KEY_PRICE       = "price"
        static let KEY_QUANTITY    = "quantity"
    }
    
    struct message {
        static let DELETE = "Record has been deleted successfully."
        static let UPDATE = "Record has been updated successfully."
        static let SAVE   = "Record has been saved successfully."
        static let CLONE  = "Record has been cloned successfully."
        static let ALL    = "Records has been retrieve successfully."
        static let NO_RECORDS    = "Looks like there are no Records available in your section."
    }
}
