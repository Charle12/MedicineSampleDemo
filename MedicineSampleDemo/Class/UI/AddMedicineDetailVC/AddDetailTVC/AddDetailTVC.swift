//
//  AddDetailTVC.swift
//  MedicineSampleDemo
//
//  Created by Prabhat Pandey on 03/09/19.
//  Copyright © 2019 Prabhat Pandey. All rights reserved.
//

import UIKit

class AddDetailTVC: UITableViewCell {
    
    private let kMaxTextLength = 9
    private let kZeroDotted = "0."
    private let kZero = "0"
    private let kDoubleDot = ".."
    private let kDot = "."
    
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblForError: UILabel!
    @IBOutlet weak var txtFieldForInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public var addressModel: AddressModel? {
        didSet {
            guard let addressModel = addressModel else { return }
            self.lblForError.text = addressModel.errorMsg
            self.lblForError.isHidden = addressModel.showError ?? true
            self.lblForTitle.text = addressModel.lblTitle
            self.txtFieldForInput.text = addressModel.txt1
            self.txtFieldForInput.tag = addressModel.tag ?? 0
            self.txtFieldForInput.placeholder = addressModel.placeHolder
            if addressModel.tag ?? 0 == 1 {
                self.txtFieldForInput.keyboardType = .decimalPad
            } else if addressModel.tag ?? 0 == 2 {
                self.txtFieldForInput.keyboardType = .numberPad
            } else {
                self.txtFieldForInput.keyboardType = .default
            }
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

extension AddDetailTVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchText = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
            addressModel!.txt1 = searchText
            addressModel!.showError = true
            if (textField.tag == 0 && (searchText).count == 0) {
                addressModel!.showError = false
            } else if (textField.tag == 1 && (searchText).count == 0) {
                addressModel!.showError = false
            } else if (textField.tag == 2 && (searchText).count == 0) {
                addressModel!.showError = false
            } else if (textField.tag == 3 && (searchText).count == 0) {
                addressModel!.showError = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            guard let oldText = textField.text, let swiftRange = Range(range, in: oldText) else {
                return true
            }
            let newText = oldText.replacingCharacters(in: swiftRange, with: string)
            // Check the statements of decimal value.
            if (newText == kDot) {
                textField.text = kZeroDotted;
                return false
            }
            if (newText.range(of: kDoubleDot) != nil) {
                textField.text = newText.replacingOccurrences(of: kDoubleDot, with: kDot);
                return false
            }
            // Check the max characters typed.
            let oldLength = textField.text?.count ?? 0
            let replacementLength = string.count
            let rangeLength = range.length
            let newLength = oldLength - rangeLength + replacementLength;
            let returnKey = string.rangeOfCharacter(from: CharacterSet.newlines) != nil
            return newLength <= kMaxTextLength || returnKey
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

