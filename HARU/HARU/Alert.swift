//
//  Alert.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/06.
//

import UIKit

extension UIViewController {
    
    func alert(title : String = "알림", message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
