//
//  ThemeSelectViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/05/03.
//

import UIKit

class ThemeSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onBtn1Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor"
    }
    @IBAction func onBtn2Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor_00"
    }
    @IBAction func onBtn3Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor_01"
    }
    @IBAction func onBtn4Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor_02"
    }
    @IBAction func onBtn5Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor_03"
    }
    @IBAction func onBtn6Clicked(_ sender: Any) {
        AppDelegate.MAIN_COLOR = "MainUIColor_04"
    }
    

}
