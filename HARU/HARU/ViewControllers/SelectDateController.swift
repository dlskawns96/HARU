//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit

class SelectDateController : UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var composeBtn: UIBarButtonItem!
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    var delegate: SelectDateControllerDelegate?
    var needCalendarReload: Bool = false

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
        AddDiaryFunction
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
            childView.addEventViewControllerDelegate = self
            self.present(controller, animated: true, completion: nil)
        case 1:
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            
            self.present(controller, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
}

// AddEventController 로 부터 일정 수정 사항이 있는지 받아오기 위한 delegate
extension SelectDateController: AddEventViewControllerDelegate {
    func newEventAdded() {
        needCalendarReload = true
    }
    
    func eventDeleted() {
        needCalendarReload = true
    }
    
    /// 구현: 이벤트 수정 사항이 없이 그냥 종료 됐을 때 처리
}

protocol SelectDateControllerDelegate: class {
    func SelectDateControllerDidCancel(_ selectDateController: SelectDateController)
    func SelectDateControllerDidFinish(_ selectDateController: SelectDateController)
}

extension SelectDateController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        dismiss(animated: true)
        if needCalendarReload {
            self.delegate?.SelectDateControllerDidFinish(self)
        }
    }
}
