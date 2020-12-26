//
//  AddScheduleController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit

class AddScheduleController : UIViewController {
    
    @IBAction func CloseBtn(_ sender: Any) {
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
}
