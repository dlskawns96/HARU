//
//  AddPictureDiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/12.
//

import UIKit

class AddPictureDiaryViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastPoint: CGPoint!
    // 선의 두께를 2.0으로 설정
    var lineSize:CGFloat = 2.0
    // 선의 색상을 빨간색으로 설정
    var lineColor = UIColor.black.cgColor
    
    @IBAction func clearBtnClicked(_ sender: Any) {
        imageView.image = nil
    }
    
    @IBAction func redBtnClicked(_ sender: Any) {
        lineColor = UIColor.red.cgColor
    }
    
    @IBAction func greenBtnClicked(_ sender: Any) {
        lineColor = UIColor.green.cgColor
    }
    
    @IBAction func blueBtnClicked(_ sender: Any) {
        lineColor = UIColor.blue.cgColor
    }
    
    @IBAction func blackBtnClicked(_ sender: Any) {
        lineColor = UIColor.black.cgColor
    }
    
    @IBAction func finishBtnClicked(_ sender: Any) {

        let alert = UIAlertController(title: "알림", message: "그림 일기를 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.saveBtn()
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    func saveBtn(){
        //그림 일기 저장 구현
        DiaryViewController.image = imageView.image
        // 닫기
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 현재 발생한 터치 이벤트를 가지고 옴
        let touch = touches.first! as UITouch
        // 터치된 위치를 lastPoint에 할당
        lastPoint = touch.location(in: imageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 그림을 그리기 위한 콘텍스트 생성
        UIGraphicsBeginImageContext(imageView.frame.size)
        // 선 색상을 설정
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        // 선 끝 모양을 라운드로 설정
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        // 선 두께를 설정
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        // 현재 발생한 터치 이벤트를 가지고 옴
        let touch = touches.first! as UITouch
        // 터치된 좌표를 currPoint로 가지고 옴
        let currPoint = touch.location(in: imageView)
        
        // 현재 imgView에 있는 전체 이미지를 imgView의 크기로 그림
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        // lastPoint 위치로 시작 위치를 이동
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        // lastPoint에서 currPoint까지 선을 추가
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        // 추가한 선을 콘텍스트에 그림
        UIGraphicsGetCurrentContext()?.strokePath()
        
        // 현재 콘텍스트에 그려진 이미지를 가지고 와서 이미지 뷰에 할당
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        // 그림 그리기를 끝냄
        UIGraphicsEndImageContext()
        
        // 현재 터치된 위치를 lastPoint라는 변수에 할당
        lastPoint = currPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        let touch = touches.first! as UITouch
        let currPoint = touch.location(in: imageView)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // 폰을 흔드는 모션이 발생하면
        if motion == .motionShake {
            let alert = UIAlertController(title: "알림", message: "그림 일기를 삭제할까요?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
                self?.imageView.image = nil
            }
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
