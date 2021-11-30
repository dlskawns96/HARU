//
//  Extensions.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/21.
//

import Foundation
import UIKit
import EventKit
import MapKit

struct Time {
    var type: DateComponentType
    var offset: Int
}

extension EKEvent: Identifiable {
    
}

extension UIImage {
    static let mainIcon = UIImage(named: "appstore")!
}

extension UIColor {
    static let mainColor = UIColor(named: "MainUIColor")!
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var startOfYear: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    var datesOfMonth: [Date] {
        var curDate = startOfMonth
        var dates = [Date]()
        while true {
            if curDate.compare(.isSameDay(as: endOfMonth.adjust(DateComponentType.day, offset: 1))) {
                break
            }
            dates.append(curDate)
            curDate = curDate.adjust(DateComponentType.day, offset: 1)
        }
        return dates
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func isSunday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 1
    }
    
    func numOfDays(In month: Date) -> Int {
        let range = Calendar(identifier: .gregorian).range(of: .day, in: .month, for: month)!
        let numDays = range.count
        return numDays
    }
    
    func difference(between day: Date) -> Int {
        let interval = self.timeIntervalSince(day)
        let days = Int(interval / 86400)
        
        return days
    }
}

extension Date {
    
    func isSameAs(as compo: Calendar.Component, from date: Date) -> Bool {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        return cal.component(compo, from: date) == cal.component(compo, from: self)
    }
    
    func dayBefore() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }
    
    func toStringUTC( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}

extension UITableView {
    func removeExtraLine() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func insertRow(indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: animation)
        self.endUpdates()
    }
    
    func deleteRow(indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.beginUpdates()
        self.deleteRows(at: [indexPath], with: animation)
        self.endUpdates()
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh:mm"
        return dateFormatter.date(from: self)!
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension EKEvent {
    func getAlarmIndex() -> IndexPath? {
        let alarmTime = [Time(type: DateComponentType.minute, offset: 0),
                         Time(type: DateComponentType.minute, offset: 5),
                         Time(type: DateComponentType.minute, offset: 10),
                         Time(type: DateComponentType.minute, offset: 15),
                         Time(type: DateComponentType.minute, offset: 30),
                         Time(type: DateComponentType.hour, offset: 1),
                         Time(type: DateComponentType.hour, offset: 2),
                         Time(type: DateComponentType.day, offset: 1),
                         Time(type: DateComponentType.day, offset: 2),
                         Time(type: DateComponentType.day, offset: 7)]
        if !self.hasAlarms {
            return nil
        }
        var idx = 0
        var indexPath = IndexPath(row: 0, section: 0)
        for time in alarmTime {
            if self.alarms?.first?.absoluteDate?.adjust(time.type, offset: time.offset).compare(self.startDate) == ComparisonResult.orderedSame {
                break
            }
            idx += 1
        }
        indexPath.section = 1
        indexPath.row = idx
        return indexPath
    }
    
    private static var calendarIndex = [String:Int]()
    var calendarIndex: Int {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return EKEvent.calendarIndex[tmpAddress] ?? 0
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            EKEvent.calendarIndex[tmpAddress] = newValue
        }
    }
    
//    private static var alarmIndex: IndexPath?
//    var alarmIndex: IndexPath? {
//        get {
//            return EKEvent.alarmIndex ?? nil
//        }
//        set(newValue) {
//            EKEvent.alarmIndex = newValue
//        }
//    }
}

extension UITextField {
    func addDoneButton() {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
}

extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
}

extension NSAttributedString {
    func concat(rhs: NSAttributedString) -> NSAttributedString {
        
        let a = self.mutableCopy() as! NSMutableAttributedString
        let b = rhs.mutableCopy() as! NSMutableAttributedString
        
        a.append(b)
        
        return a.copy() as! NSAttributedString
    }
}

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
