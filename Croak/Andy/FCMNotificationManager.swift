//
//  PushNotificationManager.swift
//  Croak
//
//  Created by Giwoo Kim on 5/24/24.
//

import Foundation

import Firebase
import FirebaseCore


import Foundation
import Firebase
import FirebaseAuth

class FCMNotificationManager {
    static let shared = FCMNotificationManager ()
    
    let baseURL = URL(string: "https://fcm.googleapis.com/v1/projects/croaksproject/messages:send")!
    var fcmToken: String = ""
    var accessToken : String = ""
    
//    func signInWithEmailAndPassword(email: String, password: String, completionHandler: @escaping (String?) -> Void) {
//        var accessToken : String = ""
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            if let error = error {
//                print("로그인 실패: \(error.localizedDescription)")
//                completionHandler(nil)
//                return
//            }
//            
//            guard let user = authResult?.user else {
//                print("사용자 정보를 가져올 수 없음.")
//                completionHandler(nil)
//                return
//            }
//            
//            print("authResult \(String(describing: authResult))")
//            // 로그인이 성공하면 사용자의 ID 토큰을 가져옵니다.
//            user.getIDToken(completion: { (token, error) in
//                if let error = error {
//                    print("토큰을 가져오는 동안 오류 발생: \(error.localizedDescription)")
//                    completionHandler(nil)
//                    return
//                }
//                
//                guard let accessToken = token else {
//                    print("토큰이 없음")
//                    completionHandler(nil)
//                    return
//                }
//                
//                // 토큰을 가져온 후 완료 핸들러에 반환합니다.
//                self.accessToken = token ?? ""
//                completionHandler(accessToken)
//                
//            })
//          
//        }
//    }
    
    func sendPushNotification(accessToken: String, fcmToken: String, title: String, body: String) {
        let headers: [String: String] = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let notificationBody: [String: Any] = [
            "message": [
                "token": fcmToken,
                "notification": [
                    "title": title,
                    "body": body
                ]
            ]
        ]
     
        guard let jsonData = try? JSONSerialization.data(withJSONObject: notificationBody) else {
            print("Error creating JSON data")
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
      //  request.allHTTPHeaderFields = headers
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending message: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                print("Successfully sent message")
            } else {
                if let  httpResponse = response as? HTTPURLResponse {
                    print("ErrorCode \(httpResponse.statusCode)")
                }
                print("Failed to send message ")
               
            }
        }.resume()
    }
}

/*
 데이터 메시지(Data Message)는 Firebase Cloud Messaging(FCM)을 통해 전송되는 메시지 유형 중 하나로, 클라이언트 애플리케이션에서 직접 처리할 수 있도록 설계된 메시지입니다. 알림 메시지(Notification Message)와 달리, 데이터 메시지는 사용자에게 즉시 알림을 표시하지 않으며, 대신 애플리케이션에서 자체적으로 로직을 처리할 수 있도록 데이터를 포함합니다.
 
 ### 데이터 메시지의 특징

 1. **직접 처리**:
    - 데이터 메시지는 클라이언트 애플리케이션으로 직접 전달되며, 앱이 실행 중일 때만 수신됩니다.
    - 앱이 백그라운드 또는 종료 상태에서는 수신되지 않습니다.

 2. **유연한 데이터 구조**:
    - 메시지 페이로드에 임의의 데이터 키-값 쌍을 포함할 수 있습니다. 이 데이터를 기반으로 애플리케이션에서 특정 작업을 수행할 수 있습니다.

 3. **알림 표시 없음**:
    - 데이터 메시지는 기본적으로 알림을 표시하지 않습니다. 필요할 경우, 수신 후 애플리케이션에서 알림을 생성할 수 있습니다.

 ### 데이터 메시지 예제

 #### 서버에서 데이터 메시지 보내기

 데이터 메시지를 보내려면, 서버에서 FCM HTTP API를 사용하여 메시지를 전송합니다. 예를 들어, 다음과 같이 JSON 형식의 요청을 보낼 수 있습니다:

 ```json
 {
   "to": "<FCM 토큰>",
   "data": {
     "title": "새로운 데이터 메시지",
     "body": "데이터 메시지 내용입니다.",
     "key1": "value1",
     "key2": "value2"
   }
 }
 ```

 이 요청은 FCM 서버로 전송되어 지정된 디바이스로 전달됩니다.

 #### iOS 클라이언트에서 데이터 메시지 처리

 `AppDelegate.swift` 파일에서 `MessagingDelegate`를 구현하여 데이터 메시지를 처리할 수 있습니다.

 ```swift
 import UIKit
 import Firebase

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

     func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         FirebaseApp.configure()
         Messaging.messaging().delegate = self
         application.registerForRemoteNotifications()
         return true
     }
 }

 extension AppDelegate: MessagingDelegate {
     
     // 데이터 메시지 수신 시 호출
     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
         print("Received data message: \(remoteMessage.appData)")
         
         // 데이터 메시지를 기반으로 원하는 작업을 수행합니다.
         // 예: 알림 생성
         if let title = remoteMessage.appData["title"] as? String,
            let body = remoteMessage.appData["body"] as? String {
             showLocalNotification(title: title, body: body)
         }
     }
     
     func showLocalNotification(title: String, body: String) {
         let content = UNMutableNotificationContent()
         content.title = title
         content.body = body
         content.sound = .default
         
         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
 }
 ```

 ### 알림 메시지와 데이터 메시지 비교

 | 특징              | 알림 메시지                    | 데이터 메시지                    |
 |------------------|-----------------------------|-----------------------------|
 | 수신 조건          | 앱이 포그라운드 또는 백그라운드에 있을 때 | 앱이 포그라운드에 있을 때만      |
 | 사용자에게 알림 표시 | 기본적으로 시스템이 알림을 표시    | 기본적으로 알림을 표시하지 않음   |
 | 처리 방법          | `UNUserNotificationCenterDelegate` | `MessagingDelegate`            |
 | 메시지 페이로드 구조 | `"notification"` 키에 포함된 데이터 | `"data"` 키에 포함된 데이터      |

 데이터 메시지를 사용하면 더 유연하게 푸시 메시지를 처리할 수 있으며, 특정 상황에서 사용자에게 알림을 표시하거나 내부 로직을 처리하는 데 유용합니다. 앱의 요구 사항에 따라 알림 메시지와 데이터 메시지를 적절히 사용하여 사용자 경험을 최적화할 수 있습니다.*/

/*
 Silent Notification(또는 Silent Push Notification)은 사용자에게 화면에 알림을 표시하지 않고 백그라운드에서 앱에 데이터를 전송하는 형태의 푸시 알림입니다. 이러한 알림은 사용자에게는 인지되지 않지만, 앱은 백그라운드에서 동작하고 데이터를 처리할 수 있습니다. Silent Notification은 주로 앱의 데이터를 업데이트하거나 동기화하는 데 사용됩니다.

 ### Silent Notification의 특징

 1. **사용자 인지 없음**: 화면에 알림이나 메시지가 표시되지 않습니다. 사용자는 이러한 알림을 인지하지 못합니다.

 2. **백그라운드 처리**: 앱이 백그라운드에 있을 때만 동작합니다. 따라서 사용자가 앱을 사용 중이지 않아도 알림이 전송됩니다.

 3. **데이터 전송**: 주로 데이터를 전송하는 용도로 사용됩니다. 예를 들어, 서버에서 앱으로 새로운 콘텐츠를 가져오거나, 데이터베이스를 업데이트하는 데 사용될 수 있습니다.

 4. **제한 사항**: iOS에서 Silent Notification을 사용하는 데는 일부 제한이 있습니다. 예를 들어, 앱이 백그라운드 상태에서 Silent Notification을 수신하려면 배터리 소모를 최소화하기 위해 앱이 주기적으로 백그라운드에서 실행되어야 합니다.

 ### Silent Notification의 사용 예

 1. **데이터 동기화**: 서버와의 동기화를 위해 주기적으로 데이터를 업데이트합니다.

 2. **캐시 갱신**: 로컬 캐시를 업데이트하여 새로운 콘텐츠를 반영합니다.

 3. **푸시 알림 로그**: 서버에서 앱에 로그 데이터를 보내어 푸시 알림에 대한 통계를 수집합니다.

 ### Silent Notification 설정

 iOS에서 Silent Notification을 사용하려면 다음과 같은 설정이 필요합니다:

 1. **백그라운드 업데이트 활성화**: 앱이 백그라운드에서 실행되어야 합니다. Background Modes를 활성화하고 Remote notifications를 선택하여 백그라운드 푸시를 허용합니다.

 2. **Silent Payload 전송**: Silent Notification을 전송할 때는 aps 필드를 포함하지 않아야 합니다. 대신 content-available 키를 1로 설정하여 Silent Notification임을 알리는 것이 중요합니다.

 ```json
 {
     "aps": {
         "content-available": 1
     },
     // 추가 데이터 필드...
 }
 ```

 ### Silent Notification의 주의사항

 1. **앱 배터리 소모**: Silent Notification을 사용할 때 앱이 주기적으로 백그라운드에서 실행되어야 하므로, 배터리 소모에 주의해야 합니다.

 2. **사용자 경험**: Silent Notification은 사용자에게 알림이 표시되지 않기 때문에, 사용자가 앱의 상태 변경을 인지하지 못할 수 있습니다.

 3. **Apple의 제한 사항**: Apple은 Silent Notification의 남용을 방지하기 위해 일부 제한을 설정할 수 있습니다. 따라서 Silent Notification의 사용은 Apple의 정책을 준수해야 합니다.

 Silent Notification은 앱의 데이터 업데이트 및 백그라운드 작업에 유용한 기술이지만, 적절한 상황에서 사용해야 하며, 사용자 경험과 배터리 소모에 영향을 미치는 점을 고려해야 합니다.
 */
