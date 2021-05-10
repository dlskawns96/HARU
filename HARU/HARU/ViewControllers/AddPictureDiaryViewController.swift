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
    @IBOutlet weak var eraserBackgroundView: UIView!
    
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
    
    // Pen Shadow View
    @IBOutlet weak var redBtnShadowView: ShadowView!
    @IBOutlet weak var greenBtnShadowView: ShadowView!
    @IBOutlet weak var blueBtnShadowView: ShadowView!
    @IBOutlet weak var indigoBtnShadowView: ShadowView!
    
    @IBOutlet weak var eraserBtnShadowView: ShadowView!
    
    @IBOutlet weak var yellowBtnShadowView: ShadowView!
    @IBOutlet weak var orangeBtnShadowView: ShadowView!
    @IBOutlet weak var darkgrayShadowView: ShadowView!
    @IBOutlet weak var blackBtnShadowView: ShadowView!
    
    let dataSource = PictureDiaryModel()
    
    var selectedDate: String!
    let dateFormatter = DateFormatter()
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    
    @IBAction func eraserBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(eraserBtnShadowView, UIColor.gray)
        lineColor = UIColor.white.cgColor
        lineSize = 35.0
    }
    
    @IBAction func redBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(redBtnShadowView, UIColor.red)
        lineColor = UIColor.red.cgColor
        lineSize = 2.0
    }
    
    @IBAction func greenBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(greenBtnShadowView, UIColor.green)
        lineColor = UIColor.green.cgColor
        lineSize = 2.0
    }
    
    @IBAction func blueBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(blueBtnShadowView, UIColor.blue)
        lineColor = UIColor.blue.cgColor
        lineSize = 2.0
    }
    
    @IBAction func indigoBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(indigoBtnShadowView, UIColor.systemIndigo)
        lineColor = UIColor.systemIndigo.cgColor
        lineSize = 2.0
    }
    
    @IBAction func yellowBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(yellowBtnShadowView, UIColor.yellow)
        lineColor = UIColor.yellow.cgColor
        lineSize = 2.0
    }
    
    @IBAction func darkgrayBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(darkgrayShadowView, UIColor.darkGray)
        lineColor = UIColor.darkGray.cgColor
        lineSize = 2.0
    }
    
    @IBAction func orangeBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(orangeBtnShadowView, UIColor.orange)
        lineColor = UIColor.orange.cgColor
        lineSize = 2.0
    }
    
    @IBAction func blackBtnClicked(_ sender: Any) {
        penBtnInit()
        penBtnClicked(blackBtnShadowView, UIColor.black)
        lineColor = UIColor.black.cgColor
        lineSize = 2.0
    }

    func penBtnClicked(_ BtnShadowView: ShadowView, _ color: UIColor) {
        BtnShadowView.shadowColor = color
        BtnShadowView.shadowBlur = 12
        BtnShadowView.shadowOffset = CGPoint(x: 0, y: 2)
        BtnShadowView.shadowOpacity = 1
    }
    
    func penBtnInit() {
        
        eraserBtnShadowView.shadowOpacity = 0
        eraserBtnShadowView.shadowBlur = 0
        eraserBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
       
        redBtnShadowView.shadowOpacity = 0
        redBtnShadowView.shadowBlur = 0
        redBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        greenBtnShadowView.shadowOpacity = 0
        greenBtnShadowView.shadowBlur = 0
        greenBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        blueBtnShadowView.shadowOpacity = 0
        blueBtnShadowView.shadowBlur = 0
        blueBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        indigoBtnShadowView.shadowOpacity = 0
        indigoBtnShadowView.shadowBlur = 0
        indigoBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        yellowBtnShadowView.shadowOpacity = 0
        yellowBtnShadowView.shadowBlur = 0
        yellowBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        orangeBtnShadowView.shadowOpacity = 0
        orangeBtnShadowView.shadowBlur = 0
        orangeBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        darkgrayShadowView.shadowOpacity = 0
        darkgrayShadowView.shadowBlur = 0
        darkgrayShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
        blackBtnShadowView.shadowOpacity = 0
        blackBtnShadowView.shadowBlur = 0
        blackBtnShadowView.shadowOffset = CGPoint(x: 0, y: 0)
        
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
        shadowView.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
        eraserBackgroundView.backgroundColor = UIColor(named: AppDelegate.MAIN_COLOR)
        eraserBackgroundView.clipsToBounds = true
        eraserBackgroundView.layer.cornerRadius = 20
        eraserBackgroundView.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMinXMaxYCorner]
      
        penBtnInit()
        
        blackBtnShadowView.shadowColor = UIColor.black
        blackBtnShadowView.shadowOpacity = 1
        blackBtnShadowView.shadowBlur = 12
        blackBtnShadowView.shadowOffset = CGPoint(x: 0, y: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
