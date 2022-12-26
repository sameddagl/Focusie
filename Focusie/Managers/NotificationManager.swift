//
//  NotificationManager.swift
//  Focusie
//
//  Created by Samed Dağlı on 16.12.2022.
//

import UIKit
import UserNotifications

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}

protocol LocalNotificationManagerProtocol {
    func cancel()
    func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo: [AnyHashable : Any]?)
}

final class LocalNotificationManager: LocalNotificationManagerProtocol {
    
    private var notifications = [LocalNotification]()
    
    private func requestPermission() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
            }
    }
    
    private func addNotification(title: String, body: String) -> Void {
        notifications.append(LocalNotification(id: UUID().uuidString, title: title, body: body))
    }
    
    private func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool, userInfo: [AnyHashable : Any]?) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            if let userInfo = userInfo {
                content.userInfo = userInfo
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(durationInSeconds), repeats: repeats)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        }
        notifications.removeAll()
    }
    
    private func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, userInfo: [AnyHashable : Any]?) {
        var seconds = 0
        switch type {
        case .seconds:
            seconds = duration
        case .minutes:
            seconds = duration * 60
        case .hours:
            seconds = duration * 60 * 60
        case .days:
            seconds = duration * 60 * 60 * 24
        }
        scheduleNotifications(seconds, repeats: repeats, userInfo: userInfo)
    }
    
    func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo: [AnyHashable : Any]?) {
        addNotification(title: title, body: body)
        scheduleNotifications(duration, of: type, repeats: repeats, userInfo: userInfo)
    }
}
