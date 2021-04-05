//
//  SettingViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/20.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    
    let header: [String] = ["설정", "알림", "서비스", "지원"]
    let setting: [[String]] = [["테마 설정"], ["알림 받기"], ["다이어리 전체 지우기"], ["앱 평가하기", "의견 남기기", "개발자 정보", "앱 정보"]]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//        var cell = UITableViewCell()
//        
//        if indexPath.section == 0 {
//            cell = tableView.dequeueReusableCell(withIdentifier: "notificationSettingCell", for: indexPath) as! NotificationSettingCell
//            
//        }
//        else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath)
//            let text: String = setting[indexPath.section][indexPath.row]
//            cell.textLabel?.text = text
//            cell.accessoryType = .disclosureIndicator
//        }
        
//        print(indexPath.section)
       

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationSettingCell", for: indexPath) as! NotificationSettingCell
            cell.label.text = setting[indexPath.section][indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath)
            let text: String = setting[indexPath.section][indexPath.row]
            cell.textLabel?.text = text
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
//        let cell = (indexPath.section == 0) ? tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath) : tableView.dequeueReusableCell(withIdentifier: "notificationSettingCell", for: indexPath) as! NotificationSettingCell
//        let text = setting[indexPath.section][indexPath.row]
//
//        if indexPath.section == 0 {
//            cell.label.text = setting[indexPath.section][indexPath.row]
//        }
//        else {
//            cell.textLabel?.text = text
//            cell.accessoryType = .disclosureIndicator
//        }
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
        
        let nibName = UINib(nibName: "NotificationSettingCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "notificationSettingCell")
    }
}

