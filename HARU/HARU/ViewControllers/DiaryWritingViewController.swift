//
//  DiaryWritingViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/08.
//

import UIKit

class DiaryWritingViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self

//        let attributedString = NSMutableAttributedString(string: "동해물과 백두산이 마르고 닳도록")
//        attributedString.addAttribute(.kern, value: 10, range: NSRange(location: 0, length: attributedString.length - 1))
//        textView.attributedText = attributedString
        
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DiaryWritingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let arbitraryValue: Int = 5
        if let newPosition = textView.position(from: textView.beginningOfDocument, offset: arbitraryValue) {
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let arbitraryValue: Int = 5
        if let newPosition = textView.position(from: textView.beginningOfDocument, offset: arbitraryValue) {
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
}
