//
//  NotificationService.swift
//  Croak
//
//  Created by Giwoo Kim on 5/31/24.
//

import Foundation


import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        // Determine whether you should suppress the notification.
        let suppress = myShouldSuppressNotification(request: request)
        
        if suppress {
            // Don't deliver the notification to the user.
            contentHandler(UNNotificationContent())
            
        } else {
            // Deliver the notification.
            guard let updatedContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
                // This error should never occur.
                fatalError("Unable to create a mutable copy of the content")
            }
            
            // Update the notification's content, such as decrypting the body, here.
            contentHandler(updatedContent)
        }
    }
    
    // Your custom suppression logic here.
    func myShouldSuppressNotification(request: UNNotificationRequest) -> Bool {
        // Implement your logic to decide whether to suppress the notification.
        if let userInfo = request.content.userInfo as? [String: Any],
           let messageIdentifier = userInfo["messageIdentifier"] as? String {
            
            // Implement your logic to decide whether to suppress the notification based on messageIdentifier
            if messageIdentifier == "TEST1" {
                return true
            }
        }
        
        return false // Example: Always deliver the notification.
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("Service time expired !!!")
    }
}

