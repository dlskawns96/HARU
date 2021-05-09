//
//  DiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class DiaryViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    
    // Evaluation View
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var bestBtn: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var evaluationView: ShadowView!
    
    // Picture Drawing View
    @IBOutlet weak var pictureDiary: UIImageView!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var squaredPaper: UIImageView!
    
    // Diary View
    @IBOutlet weak var textView: LinedTextView!
    
    var scrollOffset: CGFloat?
    
    static var image: UIImage?
    static var selectedDate: Date?
    var dSelectedDate: String?
    var dToday: String?
    
    var layerMaxXMaxYCorner: CACornerMask = []
    var layerMaxXMinYCorner: CACornerMask = []
    var layerMinXMaxYCorner: CACornerMask = []
    var layerMinXMinYCorner: CACornerMask = []
    
    var diary: Diary?
    var token: NSObjectProtocol?
    var Etoken: NSObjectProtocol?
    var Ctoken: NSObjectProtocol?
    
    var todayCheck = true
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    let dateFormatter = DateFormatter()
    let today = NSDate()
    
    let dataSource = DiaryTableViewModel()
    let imageDataSource = PictureDiaryModel()
    
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
    
    func setBtnSize(badBtnSize: Int, goodBtnSize: Int, bestBtnSize: Int) {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(badBtnSize))
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(goodBtnSize))
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(bestBtnSize))
    }

    // 평가
    @IBAction func badBtn(_ sender: Any) {
        if todayCheck {
            setBtnSize(badBtnSize: 45, goodBtnSize: 15, bestBtnSize: 15)
            
            CoreDataManager.shared.saveEvaluation(1, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
            
        }
    }
    
    @IBAction func goodBtn(_ sender: Any) {
        if todayCheck {
            setBtnSize(badBtnSize: 15, goodBtnSize: 45, bestBtnSize: 15)
            
            CoreDataManager.shared.saveEvaluation(2, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    
    }
    
    @IBAction func bestBtn(_ sender: Any) {
        if todayCheck {
            setBtnSize(badBtnSize: 15, goodBtnSize: 15, bestBtnSize: 45)
            
            CoreDataManager.shared.saveEvaluation(3, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    }

    @objc func AddPictureDiary(sender: UIGestureRecognizer) {
        if todayCheck {
            AddPictureDiaryViewController.image = pictureDiary.image
            performSegue(withIdentifier: "AddPictureDiaryView", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()

        dataSource.requestDiary(date: (AD?.selectedDate)!)
        dSelectedDate = AD?.selectedDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dToday = dateFormatter.string(from: today as Date)
        
        //pictureDiary.image = DiaryViewController.image
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AddPictureDiary(sender:)))
        self.shadowView.addGestureRecognizer(gesture)

        let evaluation = CoreDataManager.returnDiaryEvaluation(date: (AD?.selectedDate)!)
        
        if evaluation == 1 {
            setBtnSize(badBtnSize: 45, goodBtnSize: 15, bestBtnSize: 15)
        }
        else if evaluation == 2 {
            setBtnSize(badBtnSize: 15, goodBtnSize: 45, bestBtnSize: 15)
        }
        else if evaluation == 3 {
            setBtnSize(badBtnSize: 15, goodBtnSize: 15, bestBtnSize: 45)
        }
        else {
            buttonInit()
        }
        
        if dataArray.count > 0 {
            textView.text = dataArray[0].content
            
            if dataArray[0].imagePath != nil {
                let image = imageDataSource.loadImage(path: dSelectedDate!)
                pictureDiary.image = image
            }

        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource.delegate = self
    
        myView.backgroundColor = .white
        evaluationView.layer.cornerRadius = 10
        evaluationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        evaluationView.borderWidth = 5
        evaluationView.backgroundColor = UIColor(named: AppDelegate.MAIN_COLOR)
        evaluationView.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
        textView.delegate = self
        textView.tintColor = UIColor(named: AppDelegate.MAIN_COLOR)

        shadowView.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        pictureDiary.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) { [self]_ in
            dataSource.requestDiary(date: (AD?.selectedDate)!)
        }
        
        Etoken = NotificationCenter.default.addObserver(forName: DiaryViewController.newEvaluation, object: nil, queue: OperationQueue.main) {_ in

        }
        
        Ctoken = NotificationCenter.default.addObserver(forName: AddDiaryController.updateComment, object: nil, queue: OperationQueue.main) {_ in
            
        }
        
        if DiaryViewController.selectedDate!.compare(.isToday) {
            todayCheck = true
        }
        else {
            todayCheck = false
            textView.isUserInteractionEnabled = false
        }
        
        scrollOffset = textView.bounds.height / 2.0
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

extension DiaryViewController: DiaryTableViewModelDelegate {
    func didLoadData(data: [Diary]) {
        dataArray = data
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            let val = textView.caretRect(for: textView.selectedTextRange!.start)
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollOffset! + val.origin.y)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            let val = textView.caretRect(for: textView.selectedTextRange!.start)
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollOffset! + val.origin.y)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if dataArray.count > 0 {
            CoreDataManager.shared.updateDiary(textView.text, dSelectedDate)
            NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        }
        else {
            dataSource.saveDiary(content: textView.text, date: dSelectedDate!)
            NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        }        
    }
}
