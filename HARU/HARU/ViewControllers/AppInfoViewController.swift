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
    @IBOutlet weak var shadowView: ShadowView!
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        //업데이트
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.tintColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
        appImageView.image = UIImage(named: "appstore")
        appVersion.text = "Current Version : 1.0.0"
        appVersion.textColor = .gray
        shadowView.shadowColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
    }

}
