//
//  NotTodayAlert.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/05/28.
//

import Foundation

class NotTodayAlert {
    let controller = UIAlertController(title: "오늘이 아닙니다", message: "수정은 오늘날짜만 가능해요", preferredStyle: .alert)
    let alert = UIAlertAction(title: "확인", style: .default, handler: .none)
    
    func showAlert(vc: UIViewController) {
        controller.addAction(alert)
        vc.present(controller, animated: true, completion: nil)
    }
}
