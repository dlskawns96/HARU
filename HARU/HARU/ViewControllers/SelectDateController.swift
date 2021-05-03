//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit
import EventKit

class SelectDateController : UIViewController {
    
    var dSelectedDate: String?
    var dToday: String?
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet var addBtn: UIButton!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var diaryView: UIView!
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    var dateEvents: [EKEvent] = []
    
    var scheduleVC: ScheduleViewController? = ScheduleViewController()
    
    var selectedDate: Date?
    let today = NSDate()
    let dateFormatter = DateFormatter()
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ScheduleViewController 에 이벤트 정보 넘기기
        dateEvents = AD?.selectedDateEvents ?? []
        scheduleVC = (segue.destination as? ScheduleViewController) ?? nil
        
        if (scheduleVC != nil), segue.identifier == "ScheduleViewSegue" {
            scheduleVC?.dateEvents = dateEvents
            dateFormatter.dateFormat = "yyyy-MM-dd"
            scheduleVC?.selectedDate = dateFormatter.date(from: (AD?.selectedDate)!)!
        } else if segue.identifier == "AddNewEventViewController" {
            guard let controller = segue.destination as? AddNewEventViewController else { return }
            controller.selectedDate = selectedDate!
        } else if segue.identifier == "DiaryViewSegue" {
            guard let controller = segue.destination as? DiaryViewController else {
                return
            }
            controller.selectedDate = self.selectedDate
        }
        
        // 날짜 설정
        dSelectedDate = AD?.selectedDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dToday = dateFormatter.string(from: today as Date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
        isModalInPresentation = true
        self.presentationController?.delegate = self
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor  = UIColor(named: "MainUIColor")
        self.navigationItem.title = dateFormatter.string(from: selectedDate!)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            scheduleView.isHidden = false
            diaryView.isHidden = true
            addBtn.isHidden = false
            addBtn.isEnabled = true

        case 1:
            scheduleView.isHidden = true
            diaryView.isHidden = false
            addBtn.isHidden = true

        default:
            break
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewEventViewController", sender: nil)
    }
}

extension SelectDateController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
    }
}
