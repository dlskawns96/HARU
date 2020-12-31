//
//  AddDiaryController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/01.
//

import UIKit

class AddDiaryController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancleBtn(_ sender: Any) {
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {

    }
    
}
