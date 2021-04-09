//
//  DeveloperInfoViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/06.
//

import UIKit

class DeveloperInfoViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let nameArray = ["Lee Nam Jun", "Cho Si Yeon"]
    let photoArray = ["leenamjun.png", "chosiyeon.png"]
    let emailArray = ["dlskawns96@gmail.com", "chosiyeonn@gmail.com"]
    let githubArray = ["https://github.com/dlskawns96", "https://github.com/CHOSIYEON"]
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.tintColor = ThemeVariables.mainUIColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        let nibName = UINib(nibName: "DeveloperInfoCellTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "developerCell")

    }

}

extension DeveloperInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "developerCell", for: indexPath) as! DeveloperInfoCellTableViewCell
        
        cell.photo.image = UIImage(named: photoArray[indexPath.row])
        cell.name.text = nameArray[indexPath.row]
        cell.email.text = emailArray[indexPath.row]
        cell.githubAddress.text = githubArray[indexPath.row]
        
        cell.email.sizeToFit()
        cell.githubAddress.sizeToFit()
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 200
    }
    
    
}
