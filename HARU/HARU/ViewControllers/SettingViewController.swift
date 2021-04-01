//
//  SettingViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/20.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    
    let korean: [String] = ["가", "나", "다", "라"]
    let english: [String] = ["a", "b", "c"]
    
    let header: [String] = ["설정", "알림", "지원"]
    let setting: [String] = ["테마 설정", "알림 받기", "개발자 정보"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath)
        let text: String = setting[indexPath.section]
        cell.textLabel?.text = text
        
        return cell
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = ThemeVariables.mainUIColor

    }
}

