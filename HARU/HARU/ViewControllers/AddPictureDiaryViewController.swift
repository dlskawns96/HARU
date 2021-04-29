//
//  AddPictureDiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/12.
//

import UIKit

class AddPictureDiaryViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastLine: CGPoint!
    var lastContext: CGContext!
    var lastPoint: CGPoint!
    // 선의 두께를 2.0으로 설정
    var lineSize:CGFloat = 2.0
    // 선의 색상을 빨간색으로 설정
    var lineColor = UIColor.black.cgColor
    
    var originalX: Double!
    var origianlY: Double!
    
    // Pen
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var blackBtn: UIButton!
    @IBOutlet weak var eraserBtn: UIButton!
    
    @IBAction func eraserBtnClicked(_ sender: Any) {
        lineColor = UIColor.white.cgColor
        lineSize = 5.0
        
        setBtnYPosition()
        eraserBtn.frame.origin.y = CGFloat(origianlY - 25)
        
    }
    
    @IBAction func redBtnClicked(_ sender: Any) {
        lineColor = UIColor.red.cgColor
        lineSize = 2.0
        
        setBtnYPosition()
        redBtn.frame.origin.y = CGFloat(origianlY - 25)
    }
    
    @IBAction func greenBtnClicked(_ sender: Any) {
        lineColor = UIColor.green.cgColor
        lineSize = 2.0
        
        setBtnYPosition()
        greenBtn.frame.origin.y = CGFloat(origianlY - 25)
    }
    
    @IBAction func blueBtnClicked(_ sender: Any) {
        lineColor = UIColor.blue.cgColor
        lineSize = 2.0
        
        setBtnYPosition()
        blueBtn.frame.origin.y = CGFloat(origianlY - 25)
    }
    
    @IBAction func blackBtnClicked(_ sender: Any) {
        lineColor = UIColor.black.cgColor
        lineSize = 2.0
        
        setBtnYPosition()
        blackBtn.frame.origin.y = CGFloat(origianlY - 25)
    }
    
    @IBAction func finishBtnClicked(_ sender: Any) {

        let alert = UIAlertController(title: "알림", message: "그림 일기를 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.saveBtn()
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    func setBtnYPosition() {
        redBtn.frame.origin.y = CGFloat(origianlY)
        blueBtn.frame.origin.y = CGFloat(origianlY)
        greenBtn.frame.origin.y = CGFloat(origianlY)
        blackBtn.frame.origin.y = CGFloat(origianlY)
        eraserBtn.frame.origin.y = CGFloat(origianlY)
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
        
        let context = UIGraphicsGetCurrentContext()
        // 선 색상을 설정
        context!.setStrokeColor(lineColor)
        // 선 끝 모양을 라운드로 설정
        context!.setLineCap(CGLineCap.round)
        // 선 두께를 설정
        context!.setLineWidth(lineSize)
        
        // 현재 발생한 터치 이벤트를 가지고 옴
        let touch = touches.first! as UITouch
        // 터치된 좌표를 currPoint로 가지고 옴
        let currPoint = touch.location(in: imageView)
        
        // 현재 imgView에 있는 전체 이미지를 imgView의 크기로 그림
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        // lastPoint 위치로 시작 위치를 이동
        context!.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        // lastPoint에서 currPoint까지 선을 추가
        context!.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        // 추가한 선을 콘텍스트에 그림
        context!.strokePath()
        
        lastContext = context
        // 현재 콘텍스트에 그려진 이미지를 가지고 와서 이미지 뷰에 할당
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        // 그림 그리기를 끝냄
        UIGraphicsEndImageContext()
        
        // 현재 터치된 위치를 lastPoint라는 변수에 할당
        lastPoint = currPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setStrokeColor(lineColor)
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(lineSize)
        
        let touch = touches.first! as UITouch
        let currPoint = touch.location(in: imageView)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        context!.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        context!.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        context!.strokePath()
        
        lastLine = CGPoint(x: currPoint.x, y: currPoint.y)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        origianlY = Double(redBtn.frame.origin.y)
        
        let penImg = UIImage(named: "Pen")?.withRenderingMode(.alwaysTemplate)
        
        redBtn.setImage(penImg, for: .normal)
        redBtn.tintColor = UIColor.red
        
        blueBtn.setImage(penImg, for: .normal)
        blueBtn.tintColor = UIColor.blue
        
        greenBtn.setImage(penImg, for: .normal)
        greenBtn.tintColor = UIColor.green
        
        blackBtn.setImage(penImg, for: .normal)
        blackBtn.tintColor = UIColor.black

    }
}
