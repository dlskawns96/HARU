//
//  AddPictureDiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/12.
//

import UIKit

class AddPictureDiaryViewController : UIViewController {
    
    static var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: ShadowView!
    
    var lastLine: CGPoint!
    var lastContext: CGContext!
    var lastPoint: CGPoint!

    var lineSize:CGFloat = 2.0

    var lineColor = UIColor.black.cgColor
    
    var originalX: Double!
    var origianlY: Double!
    
    // Pen
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var indigoBtn: UIButton!
    
    @IBOutlet weak var eraserBtn: UIButton!
    
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var orangeBtn: UIButton!
    @IBOutlet weak var darkgrayBtn: UIButton!
    @IBOutlet weak var blackBtn: UIButton!
    
    let dataSource = PictureDiaryModel()
    
    var selectedDate: String!
    let dateFormatter = DateFormatter()
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    
    @IBAction func eraserBtnClicked(_ sender: Any) {
        lineColor = UIColor.white.cgColor
        lineSize = 5.0
    }
    
    @IBAction func redBtnClicked(_ sender: Any) {
        lineColor = UIColor.red.cgColor
        lineSize = 2.0
    }
    
    @IBAction func greenBtnClicked(_ sender: Any) {
        lineColor = UIColor.green.cgColor
        lineSize = 2.0
    }
    
    @IBAction func blueBtnClicked(_ sender: Any) {
        lineColor = UIColor.blue.cgColor
        lineSize = 2.0
    }
    
    @IBAction func indigoBtnClicked(_ sender: Any) {
        lineColor = UIColor.systemIndigo.cgColor
        lineSize = 2.0
    }
    
    @IBAction func yellowBtnClicked(_ sender: Any) {
        lineColor = UIColor.yellow.cgColor
        lineSize = 2.0
    }
    
    @IBAction func darkgrayBtnClicked(_ sender: Any) {
        lineColor = UIColor.darkGray.cgColor
        lineSize = 2.0
    }
    
    @IBAction func orangeBtnClicked(_ sender: Any) {
        lineColor = UIColor.orange.cgColor
        lineSize = 2.0
    }
    
    @IBAction func blackBtnClicked(_ sender: Any) {
        lineColor = UIColor.black.cgColor
        lineSize = 2.0
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
        dataSource.saveImage(image: imageView.image!, path: selectedDate)
        // 닫기
        self.navigationController?.popViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        lastPoint = touch.location(in: imageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 그림을 그리기 위한 콘텍스트 생성
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
        
        lastContext = context
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
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

        selectedDate = AD?.selectedDate
        imageView.image = AddPictureDiaryViewController.image
        
        imageView.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        shadowView.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
