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
    @IBOutlet weak var composeBtn: UIBarButtonItem!
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    var dateEvents: [EKEvent] = []
    
    var scheduleVC: ScheduleViewController? = ScheduleViewController()
    
    @IBAction func composeBtn(_ sender: Any) {
        if segment.selectedSegmentIndex == 1 {
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            self.present(controller, animated: true, completion: nil)
            AddDiaryController.editTarget = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        }
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segment.selectedSegmentIndex == 1 {
    //            if let vc = segue.destination.children.first as? AddDiaryController {
    //                vc.editTarget = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
    //            }
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ScheduleViewController 에 이벤트 정보 넘기기
        dateEvents = AD?.selectedDateEvents ?? []
        scheduleVC = (segue.destination as? ScheduleViewController) ?? nil
        
        if (scheduleVC != nil), segue.identifier == "ScheduleViewSegue" {
            scheduleVC?.dateEvents = dateEvents
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            scheduleVC?.selectedDate = dateFormatter.date(from: (AD?.selectedDate)!)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
        composeBtn.isEnabled = false
        isModalInPresentation = true
        self.presentationController?.delegate = self
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            scheduleView.isHidden = false
            diaryView.isHidden = true
            composeBtn.isEnabled = false
        case 1:
            scheduleView.isHidden = true
            diaryView.isHidden = false
            composeBtn.isEnabled = true
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
            controller.modalPresentationStyle = .pageSheet
            self.present(controller, animated: true, completion: nil)
        case 1:
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            
            self.present(controller, animated: true, completion: nil)
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
