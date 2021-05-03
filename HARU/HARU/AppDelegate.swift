//
//  AppDelegate.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import CoreData
import DropDown
import EventKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let colorChanged = Notification.Name(rawValue: "MainColorChanged")
    
    static var MAIN_COLOR = "MainUIColor" {
        didSet {
            UserDefaults.standard.setValue(AppDelegate.MAIN_COLOR, forKey: "MAIN_COLOR")
            NotificationCenter.default.post(name: AppDelegate.colorChanged, object: nil)
        }
    }
    
    var window: UIWindow?
    var selectedDate: String?
    var selectedDateEvents: [EKEvent]?  // 선택한 날짜의 이벤트들 저장
    let userNotificationCenter = UNUserNotificationCenter.current()
    let notificationTitle = "오늘 하루를 기록하세요"
    let notificationMessages = ["오늘은 무슨 일이 있었나요?", "오늘 하루는 어땠나요?", "오늘도 수고하셨어요"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.register(defaults: ["NotificationAllowState" : true, "MAIN_COLOR" : "MainUIColor_04"])
        AppDelegate.MAIN_COLOR = UserDefaults.standard.string(forKey: "MAIN_COLOR")!
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: UISceneSession Lifecycle
    func applicationDidFinishLaunching(_ application: UIApplication) {
        DropDown.startListeningToKeyboard()
    }
    
    private func getNotificationTime() -> DateComponents {
        var dateComponent = DateComponents()
        dateComponent.hour = 9
        dateComponent.minute = 0
        //        guard let date = UserDefaults.standard.object(forKey: "DiaryNotificationDate") as? Date else {
        //            return dateComponent
        //        }
        //        dateComponent.hour = Calendar.current.component(.hour, from: date)
        //        dateComponent.minute = Calendar.current.component(.minute, from: date)
        return dateComponent
    }
    
    private func registerForRemoteNotifications() {
        userNotificationCenter.getNotificationSettings { [self] (settings) in
            if(settings.authorizationStatus == .authorized) {
                print("Notification Auth: true")
            } else {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                userNotificationCenter.requestAuthorization(options: options, completionHandler: { (didAllow, Error) in
                    print("Notification Auth: allowed")
                    UserDefaults.standard.set(true, forKey: "NotificationSwitchState")
                    sendNotification(date: getNotificationTime())
                })
            }
        }        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 토큰 등록 실패 시 호출
    }
    
    func sendNotification(date: DateComponents) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        print("Notification Set:", date)
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = notificationTitle
        notificationContent.body = notificationMessages.randomElement()!
        
        userNotificationCenter.removeAllDeliveredNotifications()
        let request = UNNotificationRequest(identifier: "DiaryNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
