//
//  SettingViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/20.
//

import UIKit
import MessageUI
import Foundation

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let composeView = MFMailComposeViewController()

    static var deleteCheck = false
    
    var appVersion = "0.0.0"
    let dataSource = DiaryTableViewModel()
    let header: [String] = ["설정", "서비스", "지원"]
    let setting: [[String]] = [["테마 설정"], ["다이어리 전체 지우기"], ["의견 보내기", "개발자 정보", "앱 정보"]]
    
    private func checkEmailAvailability() {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            
            let alert = UIAlertController(title:
                                            "알림", message: "디바이스에 이메일을 등록해주세요!", preferredStyle: .alert)
           
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in }
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        else {
            composeEmail()
        }
    }
    
    func composeEmail() {
        composeView.setToRecipients(["chosiyeonn@gmail.com", "dlskawns96@gmail.com"])
        composeView.setSubject("[HARU] 의견 보내기 :-)")
        composeView.setMessageBody("Some Message", isHTML: false)
        
        self.present(composeView, animated: true, completion: nil)
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
    
    func appEvaluation() {
        let alert = UIAlertController(title:
                                        "알림", message: "아직 준비되지 않은 기능이에요!", preferredStyle: .alert)
       
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CoreDataManager.shared.fetchDiary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.separatorInset.left = 0

        composeView.mailComposeDelegate = self
        
        var nibName = UINib(nibName: "NotificationSettingCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "notificationSettingCell")
        
        nibName = UINib(nibName: "AppVersionCellTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "appVersionCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "themeSetView" {
            
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "themeSetView", sender: nil)
        case 1:
            let alert = UIAlertController(title: "알림", message: "모든 다이어리를 정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
                self?.deleteAllDiary()
            }
            alert.addAction(okAction)
            
            let cancleAction = UIAlertAction(title: "취소", style: .cancel) { (action) in }
            alert.addAction(cancleAction)
            
            present(alert, animated: true, completion: nil)
        case 2:
            switch indexPath.row {
//            case 0:
//                print("앱 평가")
//                appEvaluation()
            case 0:
                //performSegue(withIdentifier: "opinionView", sender: nil)
                checkEmailAvailability()
            case 1:
                print("개발자 정보")
                performSegue(withIdentifier: "DeveloperInfoView", sender: nil)
            case 2:
                print("앱 정보")
                performSegue(withIdentifier: "AppInfoView", sender: nil)
            default:
                print("nothing")
            }
            
        default:
            print("nothing")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 && indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appVersionCell", for: indexPath) as! AppVersionCellTableViewCell
            cell.label.text = setting[indexPath.section][indexPath.row]
            cell.versionLabel.text = appVersion
            cell.versionLabel.textColor = .systemGray2
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for:indexPath)
            let text: String = setting[indexPath.section][indexPath.row]
            cell.textLabel?.text = text
            cell.accessoryType = .disclosureIndicator
            cell.separatorInset.left = 0
            
            if indexPath.section == 1 {
                cell.textLabel?.textColor = .red
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}



