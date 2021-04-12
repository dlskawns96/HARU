//
//  DiaryWritingViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/08.
//

import UIKit


class DiaryWritingViewController: UIViewController {
    @IBOutlet var textView: LinedTextView!
    @IBOutlet var squaredPaper: UIImageView!
    
    var attributes: [NSAttributedString.Key: Any]!
    let kerns: [[NSAttributedString.Key: Any]] = [[.kern: 20], [.kern: 40]]
    var font: UIFont!
    
    var curPosition = 0.0
    var lineHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fontSize = squaredPaper.bounds.width / 30.0
        lineHeight = squaredPaper.bounds.height / 30.0
        
        textView.delegate = self
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
//        textView.typingAttributes = attributes
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
