//
//  NotificationManager.swift
//  Croak
//
//  Created by Giwoo Kim on 5/23/24.
//
import CoreMotion
import CoreLocation
import Foundation
import Firebase
import FirebaseMessaging
import SwiftData
import UserNotifications
import UserNotificationsUI

// LocalNotificationManager.swift
class LocalNotificationManager: NSObject{
   
    static let shared = LocalNotificationManager()
    var fcmToken : String  = ""
    
    func setAuthorization() {
      
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound ]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Authorization Error: ", error)
              
            } else {
                print("Authorization granted: \(granted)")
                DispatchQueue.main.async {
                                   UIApplication.shared.registerForRemoteNotifications()
                               }
            }
        }
    }
    
    func removePendingNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func removeDeliveredNotification(identifier: String) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
   
 
    func pushNotification(title: String, subtitle: String, body: String, seconds: Double, identifier: String , repeates: Bool) {
        // 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        notificationContent.badge = 0
  
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: repeates)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
    
     
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
        
        
    }
    
    
    //여기에  CMMOtion Data를 읽고 자세를 판단하고 데이타 베이스에 넣어준다..
    // 그리고 과거 3개의 데이터를 비교해서  3개가 같으면 Local Notification Push해주고
    // dailynotificaion을 1 증가 시켜 준다.(만약에 날짜가 같다면)
    //
    //그리고 4번째에  fix가 됬다면 fix 된것을  true로 해서 통보해주고 fix가 되지 않았다면  false 되는데
    // fix가 됬다면 fixcount += 1 증가시키고 daily가 바뀌면 notificationnumber 와 fix number를 모두 수정한다
    // notification은 3번 관찰  fix 는 4번째 까지 관찰 (notification은 3번째까지 자세가 모두 같은(notificationCount+= 1 경우(3개가 같고  4번째가 다르다면 Fixnumber +=1) 바로바로 DB를업데이트 할수도 있고 하루 마치고 업데이트 할수도있고.
    // 그러면 10분단위 자세테이블 daily통계 DB가 완성이 된다...
    
    
    private func handleSilentPushNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping (Bool) -> Void) {
        // 여기에 데이터베이스 읽기/쓰기 작업을 추가
        // 예시로 네트워크 호출 후 데이터베이스 업데이트
        print("핸들 사일런트 푸쉬노티피케이션")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentTime = Date()
        let koreanTime = dateFormatter.string(from: currentTime)
        print("핸들링 타임 " ,koreanTime)
        
        
        PostureFind().handleMotionData(){   }
        
        DispatchQueue.global().async {
            // 네트워크 요청 또는 데이터베이스 작업
            // 여기다 뭘넣지?? UIupdate
            
            let success = true // 작업 결과에 따라 true 또는 false 설정
            completionHandler(success)
        }
        
        
        
    }
// 코딩시 주의 할것 아래코드와 비교바람
//    func checkPendingNotifications() -> Int {
//        // UNUserNotificationCenter 객체 생성
//        var numberOfNotification : Int = 0
//        let center = UNUserNotificationCenter.current()
//        
//        // 현재 펜딩된 알림 요청 가져오기
//        center.getPendingNotificationRequests { requests in
//            numberOfNotification = requests.count
//            if requests.count == 0 { print("no pending notification in the closure")}
//            for request in requests {
//                print("Pending Notification: \(request.identifier)")
//            }
//        }
// 비동기 프로그램이라서 클로저 들어갔다 나오기 전에 이미 0을 리턴할것임..주의
//        return numberOfNotification
//    }
    func checkPendingNotifications(completion: @escaping (Int) -> Void) {
           let center = UNUserNotificationCenter.current()
           center.getPendingNotificationRequests { requests in
               let numberOfNotifications = requests.count
               if requests.count == 0 {
                   print("no pending notification")
               }
               for request in requests {
                   print("Pending Notification: \(request.identifier) \(numberOfNotifications)")
               }
               completion(numberOfNotifications)
           }
       }
}


