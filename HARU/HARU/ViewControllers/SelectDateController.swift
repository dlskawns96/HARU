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

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.isHidden = false
        diaryView.isHidden = true
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            scheduleView.isHidden = false
            diaryView.isHidden = true
        case 1:
            scheduleView.isHidden = true
            diaryView.isHidden = false
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
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddEventViewController") else { return }
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
