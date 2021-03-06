//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit
import EventKit

class SelectDateController : UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    var dateEvents: [EKEvent] = []
    
    var scheduleVC: ScheduleViewController? = ScheduleViewController()
    
    var selectedDate = Date()
    let dateFormatter = DateFormatter()
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ScheduleViewController 에 이벤트 정보 넘기기
        dateEvents = AD?.selectedDateEvents ?? []
        scheduleVC = (segue.destination as? ScheduleViewController) ?? nil
        
        if (scheduleVC != nil), segue.identifier == "ScheduleViewSegue" {
            scheduleVC?.dateEvents = dateEvents
            dateFormatter.dateFormat = "yyyy-MM-dd"
            scheduleVC?.selectedDate = dateFormatter.date(from: (AD?.selectedDate)!)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
        isModalInPresentation = true
        self.presentationController?.delegate = self
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        selectedDateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            scheduleView.isHidden = false
            diaryView.isHidden = true
            addBtn.isEnabled = true
        case 1:
            scheduleView.isHidden = true
            diaryView.isHidden = false
            
            // 다이어리 추가 비활성화
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: selectedDate)
            
            let today = NSDate()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let todayString = dateFormatter.string(from: today as Date)

            if dateString >= todayString {
                addBtn.isEnabled = true
            }
            else {
                addBtn.isEnabled = false
            }
            
        default:
            break
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            let storyboard: UIStoryboard = UIStoryboard(name: "AddEvent", bundle: nil)
            guard let controller = storyboard.instantiateViewController(identifier: "AddEventNavigationViewController") as UINavigationController? else { return }
            
            guard let vc = controller.viewControllers.first as? AddEventViewController else { return }
            vc.eventDate = selectedDate.adjust(hour: 9, minute: 0, second: 0)
            
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        case 1:
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            self.present(controller, animated: true, completion: nil)
            
            AddDiaryController.editTarget = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        default:
            break
        }
        
    }
}

extension SelectDateController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
    }
}
