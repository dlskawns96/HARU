//
//  DeveloperInfoViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/06.
//

import UIKit

class DeveloperInfoViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.tintColor = ThemeVariables.mainUIColor
        // Do any additional setup after loading the view.
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
