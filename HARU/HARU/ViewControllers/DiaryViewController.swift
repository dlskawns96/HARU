//
//  DiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class DiaryViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate {
        
    @IBOutlet weak var pictureDiary: UIImageView!
    @IBOutlet weak var shadowView: ShadowView!
    
    static var image: UIImage?
    var selectedDate: Date?
    var dSelectedDate: String?
    var dToday: String?
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var bestBtn: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var evaluationView: ShadowView!
    
    var layerMaxXMaxYCorner: CACornerMask = []
    var layerMaxXMinYCorner: CACornerMask = []
    var layerMinXMaxYCorner: CACornerMask = []
    var layerMinXMinYCorner: CACornerMask = []
    
    var diary: Diary?
    var token: NSObjectProtocol?
    var Etoken: NSObjectProtocol?
    var Ctoken: NSObjectProtocol?
    
    var addCheck = true
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    let dateFormatter = DateFormatter()
    let today = NSDate()
    
    let dataSource = DiaryTableViewModel()
    var dataArray = [Diary]() {
        didSet {
            //tableView.reloadData()
        }
    }
    
    func buttonInit() {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func setComment() {
        
        let comments = ["지나간 하루는 돌아오지 않아요!", "지난날에 대한 후회는 하지 마세요!", "이미 지나버렸어요", "앞으로는 바로바로 기록해요!"]
        let able_comments = ["오늘 하루는 어땠나요?", "오늘 하루를 기록하세요!", "오늘의 기록을 추가하세요!"]
        let future_comments = ["아직 오지 않은 하루에요!", "어떤일이 일어날까요?"]

//        if selectedDate!.compare(.isToday) {
//            if dataArray.count >= 1 && dataArray[0].content != " " {
//                centerLabel.isHidden = true
//            } else {
//                centerLabel.isHidden = false
//                centerLabel.text = able_comments.randomElement()
//            }
//        } else {
//            if dataArray.count >= 1 && dataArray[0].content != " " {
//                centerLabel.isHidden = true
//            } else {
//                centerLabel.isHidden = false
//                centerLabel.text = comments.randomElement()
//            }
//        }
//        if dSelectedDate == dToday {
//            if dataArray.count >= 1 && dataArray[0].content != " " {
//                centerLabel.isHidden = true
//            } else {
//                centerLabel.isHidden = false
//                centerLabel.text = able_comments.randomElement()
//            }
//        } else {
//            if dSelectedDate! < dToday! {
//                if dataArray.count >= 1 && dataArray[0].content != " " {
//                    centerLabel.isHidden = true
//                } else {
//                    centerLabel.isHidden = false
//                    centerLabel.text = comments.randomElement()
//                }
//            }
//            else {
//                centerLabel.isHidden = false
//                centerLabel.text = future_comments.randomElement()
//            }
//        }
    }
    
    // 평가
    @IBAction func badBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            CoreDataManager.shared.saveEvaluation(1, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
            
        }
    }
    
    @IBAction func goodBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            CoreDataManager.shared.saveEvaluation(2, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    
    }
    
    @IBAction func bestBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            
            CoreDataManager.shared.saveEvaluation(3, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    }
    
//    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
//
//        let content = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
//
//        if dataArray.count != 0 && content != " " {
//
//            var touchPoint = CGPoint()
//
//            if gestureRecognizer.state == UIGestureRecognizer.State.began {
//                touchPoint = gestureRecognizer.location(in: self.tableView)
//            }
//            let alert = UIAlertController(title:
//                                            "삭제 확인", message: "일기를 삭제할까요?", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "삭제", style: .destructive) { [self] (action) in
//                let indexPath = self.tableView.indexPathForRow(at: touchPoint)
//                let target = CoreDataManager.diaryList[indexPath!.row]
//                dataSource.deleteDiary(diary: target, date: (AD?.selectedDate)!)
//                self.tableView.reloadData()
//                self.buttonInit()
//                self.setComment()
//
//            }
//            alert.addAction(okAction)
//
//            let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//            alert.addAction(cancleAction)
//
//            present(alert, animated: true, completion: nil)
//        }
//    }
    
    @objc func goPage(sender: UIGestureRecognizer) {
        print("ok")
        performSegue(withIdentifier: "AddPictureDiaryView", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()
        //tableView.reloadData()

        dataSource.requestDiary(date: (AD?.selectedDate)!)
        dSelectedDate = AD?.selectedDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dToday = dateFormatter.string(from: today as Date)
        
        pictureDiary.image = DiaryViewController.image
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goPage(sender:)))
        self.shadowView.addGestureRecognizer(gesture)

        let evaluation = CoreDataManager.returnDiaryEvaluation(date: (AD?.selectedDate)!)
        
        if evaluation == 1 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else if evaluation == 2 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else if evaluation == 3 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
        }
        else {
            buttonInit()
        }
        
        setComment()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
        
        dataSource.delegate = self
    
        myView.backgroundColor = .white
        evaluationView.layer.cornerRadius = 10
        evaluationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        evaluationView.borderWidth = 5
        evaluationView.backgroundColor = ThemeVariables.mainUIColor
        evaluationView.borderColor = ThemeVariables.mainUIColor

        
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture))
//        longPressGesture.delegate = self
        //self.tableView.addGestureRecognizer(longPressGesture)
        
        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) { [self]_ in
            dataSource.requestDiary(date: (AD?.selectedDate)!)
            //self.tableView.reloadData()
        }
        
        Etoken = NotificationCenter.default.addObserver(forName: DiaryViewController.newEvaluation, object: nil, queue: OperationQueue.main) {_ in
            //self.tableView.reloadData()
        }
        
        Ctoken = NotificationCenter.default.addObserver(forName: AddDiaryController.updateComment, object: nil, queue: OperationQueue.main) {_ in
            self.setComment()
        }

        
        let dateString = AD?.selectedDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = dateFormatter.string(from: today as Date)
        
//        if selectedDate!.compare(.isToday) {
//            addCheck = true
//        }
//        else {
//            addCheck = false
//        }
        
        if dateString == todayString {
            addCheck = true
        }
        else {
            addCheck = false
        }
        
//        let nibName = UINib(nibName: "DiaryDrawViewCell", bundle: nil)
//        tableView.register(nibName, forCellReuseIdentifier: "diarydrawCell")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        if let Etoken = Etoken {
            NotificationCenter.default.removeObserver(Etoken)
        }
        
        if let Ctoken = Ctoken {
            NotificationCenter.default.removeObserver(Ctoken)
        }
    }
}

extension DiaryViewController {
    static let newEvaluation = Notification.Name(rawValue: "newEvaluation")
}

//extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
///        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
///       cell.textLabel?.text = dataArray[indexPath.row].content
///       cell.selectionStyle = .none
//        let cell = tableView.dequeueReusableCell(withIdentifier: "diarydrawCell", for: indexPath) as! DiaryDrawViewCell
//        cell.titleLabel.text = dataArray[indexPath.row].content
//        cell.diaryImage.image = DiaryViewController.image
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//        let content = dataArray[indexPath.row].content
//
//        if content != " " {
//            return true
//        }
//        else {
//            return false
//        }
//
//    }

//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "삭제", handler: { [self](action, view, completionHandler) in
//            let target = CoreDataManager.diaryList[indexPath.row]
//            dataSource.deleteDiary(diary: target, date: (AD?.selectedDate)!)
//            buttonInit()
//            setComment()
//        })
//        action.backgroundColor = .systemRed
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//
//    // trailing swipe
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "수정", handler: { [self](action, view, completionHandler) in
//            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
//            self.present(controller, animated: true, completion: nil)
//
//            AddDiaryController.editTarget = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
//        })
//        action.backgroundColor = .systemBlue
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            performSegue(withIdentifier: "AddPictureDiaryView", sender: nil)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
//}

extension DiaryViewController: DiaryTableViewModelDelegate {
    func didLoadData(data: [Diary]) {
        dataArray = data
    }
}
