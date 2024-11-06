//
//  notificateFunc.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//

import Foundation

import UserNotifications
import ActivityKit


// live activity 알림을 띄우는 함수
func showLiveActivityNotification(posture: PostureToKor) {
//    if posture == PostureToKor.LYING_LEFT {
//        dismissLiveActivityNotification()
//        return
//    }
    
    print("aa \(posture)")
    
    let content = UNMutableNotificationContent()
    content.title = "너무 오랜 시간 같은 자세를 지속하고 있습니다!"
    content.body = "다른 자세로 바꿔주세요. 척추 무너지는 중"
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "liveActivityNotification" // "live activity" 카테고리로 지정
    
    let request = UNNotificationRequest(identifier: "LiveActivityNotification", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request)
    
    let notificatePostureAttributes = NotificatePostureAttributes(name: "test")
    let contentState = NotificatePostureAttributes.ContentState(posture: posture.rawValue)
    
    do {
        let activity = try Activity<NotificatePostureAttributes>.request(
            attributes: notificatePostureAttributes,
            contentState: contentState
        )
        print(activity)
    } catch {
        print(error)
    }
}

func dismissLiveActivityNotification() {
    // 해당 식별자를 사용하여 알림을 삭제합니다.
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LiveActivityNotification"])
}

// 알림 권한을 요청하는 함수
func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            print("Notification authorization granted")
        } else {
            print("Notification authorization denied")
        }
    }
}
