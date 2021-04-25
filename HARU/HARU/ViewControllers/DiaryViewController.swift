//
//  DiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class DiaryViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate {
     
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
    
    
    var attributes: [NSAttributedString.Key: Any]!
    let kerns: [[NSAttributedString.Key: Any]] = [[.kern: 20], [.kern: 40]]
    var font: UIFont!
    
    var curPosition = 0.0
    var lineHeight = CGFloat()
    
    static var image: UIImage?
    var selectedDate: Date?
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
    
    func setBtnSize(badBtnSize: Int, goodBtnSize: Int, bestBtnSize: Int) {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(badBtnSize))
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(goodBtnSize))
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(bestBtnSize))
    }

    // 평가
    @IBAction func badBtn(_ sender: Any) {
        if addCheck {
            setBtnSize(badBtnSize: 45, goodBtnSize: 15, bestBtnSize: 15)
            
            CoreDataManager.shared.saveEvaluation(1, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
            
        }
    }
    
    @IBAction func goodBtn(_ sender: Any) {
        if addCheck {
            setBtnSize(badBtnSize: 15, goodBtnSize: 45, bestBtnSize: 15)
            
            CoreDataManager.shared.saveEvaluation(2, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    
    }
    
    @IBAction func bestBtn(_ sender: Any) {
        if addCheck {
            setBtnSize(badBtnSize: 15, goodBtnSize: 15, bestBtnSize: 45)
            
            CoreDataManager.shared.saveEvaluation(3, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    }

    @objc func AddPictureDiary(sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "AddPictureDiaryView", sender: nil)
    }
    
    func setTextViewPosition() {
        textView.backgroundColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: squaredPaper.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: squaredPaper.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: squaredPaper.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()

        dataSource.requestDiary(date: (AD?.selectedDate)!)
        dSelectedDate = AD?.selectedDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dToday = dateFormatter.string(from: today as Date)
        
        pictureDiary.image = DiaryViewController.image
        
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
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource.delegate = self
    
        myView.backgroundColor = .white
        evaluationView.layer.cornerRadius = 10
        evaluationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        evaluationView.borderWidth = 5
        evaluationView.backgroundColor = ThemeVariables.mainUIColor
        evaluationView.borderColor = ThemeVariables.mainUIColor
        
        let fontSize = squaredPaper.bounds.width / 30.0
        lineHeight = squaredPaper.bounds.height / 30.0
        
        textView.delegate = self

        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) { [self]_ in
            dataSource.requestDiary(date: (AD?.selectedDate)!)
        }
        
        Etoken = NotificationCenter.default.addObserver(forName: DiaryViewController.newEvaluation, object: nil, queue: OperationQueue.main) {_ in

        }
        
        Ctoken = NotificationCenter.default.addObserver(forName: AddDiaryController.updateComment, object: nil, queue: OperationQueue.main) {_ in
            
        }
        
        if selectedDate!.compare(.isToday) {
            addCheck = true
        }
        else {
            addCheck = false
        }
        
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
//        textView.typingAttributes = attributes
    }
}
