//
//  SetDateTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/15.
//

import UIKit
import FSCalendar

class SetDateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var amPmSeg: UISegmentedControl!
    @IBOutlet weak var hourTF: UITextField!
    @IBOutlet weak var minuteTF: UITextField!
    
    var isKeyboardUp = false
    var activeField: UITextField!
    
    var data = [
        ["a", "b", "c", "d", "e"],
        ["a", "b", "c", "d", "e"]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        amPmSeg.setTitle("오전", forSegmentAt: 0)
        amPmSeg.setTitle("오후", forSegmentAt: 1)
        
        hourTF.delegate = self
        minuteTF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SetDateTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isKeyboardUp = true
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isKeyboardUp = false
        activeField = nil
        if textField == hourTF {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            switch typedTime {
                case 0...12:
                    return
                case 13...99:
                    textField.text = "12"
                default:
                    return
            }
        }
        if textField == minuteTF {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            switch typedTime {
                case 0...59:
                    return
                case 60...99:
                    textField.text = "59"
                default:
                    return
            }
        }
    }
    
    // Return 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == minuteTF || textField == hourTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
         
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         
            return updatedText.count <= 2
        }
        return true
    }
}
