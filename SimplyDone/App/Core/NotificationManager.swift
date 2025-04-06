//
//  NotificationManager.swift
//  SimplyDone
//
//  Created by Prateek Arora on 01/04/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // Request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications Permission Granted")
            } else {
                print("Notifications Permission Denied")
            }
        }
    }

    // Schedule task reminder notification
    func scheduleTaskReminder(for task: Task) {
        guard !task.isCompleted else { return } // Skip completed tasks
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to complete: \(task.title)"
        content.sound = .default

        // Trigger notification after 5 seconds for demo (change as needed)

        if let dueDate = task.dueDate {
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("✅ Notification scheduled for task: \(task.title)")
                }
            }
        }
        
        // Create notification request
     
    }

    // Remove notification if task is deleted
    func removeNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}
