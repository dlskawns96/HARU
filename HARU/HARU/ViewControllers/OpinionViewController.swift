//
//  OpinionViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/06.
//

import UIKit

class OpinionViewController: UIViewController {

    @IBOutlet weak var sendBtn: UIBarButtonItem!
    @IBOutlet weak var opinionTextView: UITextView!
    
    func popView() {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        print(opinionTextView.text!)
        
        let alert = UIAlertController(title: "알림", message: "의견 감사합니다 :-)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] (action) in popView()}
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
        
    }
    
    func back(sender: UIBarButtonItem) {
        print("yesy")
      // your code
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        sendBtn.isEnabled = false
        opinionTextView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.tintColor = .white
        
        opinionTextView.text = ""

        // Do any additional setup after loading the view.
    }
}

extension OpinionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let edited = textView.text {
            if edited.count > 0 {
                sendBtn.isEnabled = true
            }
        }
    }
}
