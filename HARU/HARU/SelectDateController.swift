//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit

class SelectDateController : UIViewController{
    
    
    @IBOutlet weak var date: UILabel!
    
    var paramDate : String = ""
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "AddScheduleController") as? AddScheduleController else { return }
        
        self.present(controller, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.date.text = paramDate
        
    }
    
}
