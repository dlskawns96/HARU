//
//  AlertTextGenerator.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/05/28.
//

import Foundation

class AlertTextGenerator {
    let tails = ["이벤트 당시", "분 전", "시간 전", "일 전"]
    let times = [0, 60, 60 * 60, 60 * 60 * 24]
    
    func getAlertText(offset: TimeInterval) -> String {
        var text = "이벤트 당시"
        
        for idx in stride(from: times.count - 1, to: 0, by: -1) {
            if -Int(offset) >= times[idx] {
                text = String(-Int(offset) / times[idx]) + tails[idx]
                break
            }
        }
        
        return text
    }
}
