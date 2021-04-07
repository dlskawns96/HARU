//
//  SettingViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/20.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    
    static var deleteCheck = false
    
    let dataSource = DiaryTableViewModel()
    
    let header: [String] = ["설정", "알림", "서비스", "지원"]
    let setting: [[String]] = [["테마 설정"], ["알림 받기"], ["다이어리 전체 지우기"], ["앱 평가하기", "의견 보내기", "개발자 정보", "앱 정보"]]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if indexPath.section == 2 {
//            let alert = UIAlertController(title: "알림", message: "모든 다이어리를 정말 삭제하시겠습니까?", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
//                self?.deleteAllDiary()
//            }
//            alert.addAction(okAction)
//
//            let cancleAction = UIAlertAction(title: "취소", style: .cancel) { (action) in }
//            alert.addAction(cancleAction)
//
//            present(alert, animated: true, completion: nil)
//        }
        
        switch indexPath.section {
        case 2:
            let alert = UIAlertController(title: "알림", message: "모든 다이어리를 정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
                self?.deleteAllDiary()
            }
            alert.addAction(okAction)
            
            let cancleAction = UIAlertAction(title: "취소", style: .cancel) { (action) in }
            alert.addAction(cancleAction)
            
            present(alert, animated: true, completion: nil)
        case 3:
            switch indexPath.row {
            case 0:
                print("앱 평가")
            case 1:
                performSegue(withIdentifier: "opinionView", sender: nil)
            case 2:
                print("개발자 정보")
                performSegue(withIdentifier: "DeveloperInfoView", sender: nil)
            case 3:
                print("앱 정보")
                performSegue(withIdentifier: "AppInfoView", sender: nil)
            default:
                print("nothing")
            }

        default:
            print("nothing")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationSettingCell", for: indexPath) as! NotificationSettingCell
            cell.label.text = setting[indexPath.section][indexPath.row]
            cell.notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath)
            let text: String = setting[indexPath.section][indexPath.row]
            cell.textLabel?.text = text
            cell.accessoryType = .disclosureIndicator
            
            if indexPath.section == 2 {
                cell.textLabel?.textColor = .red
            }
            return cell
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 44
    }
    
    func deleteAllDiary() {
        
        if CoreDataManager.diaryList.count > 0 {
            dataSource.deleteAllDiaries()
            
            if SettingViewController.deleteCheck {
                let alert = UIAlertController(title: "알림", message: "모든 다이어리가 삭제되었습니다!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                alert.addAction(okAction)
                present(alert, animated: false, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "알림", message: "다이어리가 존재하지 않습니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CoreDataManager.shared.fetchDiary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = ThemeVariables.mainUIColor
        
        let nibName = UINib(nibName: "NotificationSettingCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "notificationSettingCell")
    }
}

