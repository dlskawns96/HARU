//
//  DiaryWritingViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/08.
//

import UIKit


class DiaryWritingViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    @IBOutlet var squaredPaper: UIImageView!
    
    var attributes: [NSAttributedString.Key: Any]!
    let kerns: [[NSAttributedString.Key: Any]] = [[.kern: 20], [.kern: 40]]
    var font: UIFont!
    
    var curPosition = 0.0
    var squareSize = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewPosition()
        let fontSize = view.bounds.width / 24.0
        squareSize = view.bounds.width / 12.0
        font = UIFont.systemFont(ofSize: fontSize)
    
        attributes = [.font: font, .kern: fontSize]
        
        textView.delegate = self
        textView.setupTextFields()
    }
    
    func setTextViewPosition() {
        textView.backgroundColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: squaredPaper.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: squaredPaper.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: squaredPaper.bottomAnchor).isActive = true
    }
    
}


// MARK: - UITextView Delegate
extension DiaryWritingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.typingAttributes = attributes
    }
    
    func textViewDidChange(_ textView: UITextView) {
    
//        let fontAttributes = attributes
//        let myText = textView.text
//        if myText != "" {
//            let size = (myText as! NSString).size(withAttributes: fontAttributes)
//            print(CGFloat(myText!.count % 12) * squareSize)
//            print(size.width)
//            attributes[.kern] = CGFloat(myText!.count % 12) * squareSize  - size.width
//
//            textView.typingAttributes = attributes
//
//        }
    }
    
    
}
