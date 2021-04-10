//
//  AppInfoViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/06.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        //업데이트
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.tintColor = ThemeVariables.mainUIColor
        
        appImageView.image = UIImage(named: "appImage")
        appVersion.text = "Current Version : 0.0.0"
        appVersion.textColor = .gray
        
    }

}
