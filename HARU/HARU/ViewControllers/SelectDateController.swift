//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit

class SelectDateController : UIViewController{
    
    
    @IBOutlet weak var date: UILabel!
    
    var paramDate : String = ""
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.date.text = paramDate
    }
    
    // 해당 날짜의 전체 일정 보여주기
    
    // 특정 일정 눌렀을 때 그 일정에 대한 세부 정보 표시
    
    // 특정 일정 눌렀을 때 삭제 버튼 추가
    
    // 삭제 버튼 누르면 기본 캘린더에서도 삭제 되게
    
    // 상단부는 일정 표시, 아래는 일기
    
}
