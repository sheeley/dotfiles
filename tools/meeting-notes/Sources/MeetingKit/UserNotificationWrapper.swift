//
//  UserNotificationWrapper.swift
//  meeting-notes
//
//  Created by Johnny Sheeley on 9/13/24.
//

import Foundation
import UserNotifications

/// NotificationCenterWrapper depends upon `UserNotifications` which
/// requires signed applications.
public class NotificationCenterWrapper {
    public static let userNotificationCenter = UNUserNotificationCenter.current()

    public static func requestAuth() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        let sema = DispatchSemaphore(value: 0)
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: ", error)
            }
            sema.signal()
        }
        _ = sema.wait(timeout: .distantFuture)
    }

    public static func sendNotification(title: String, body: String) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = title
        notificationContent.body = body

        let request = UNNotificationRequest(identifier: title, content: notificationContent, trigger: nil)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
