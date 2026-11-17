
//
//  Notifications.swift
//  Plants App
//
//  Created by ghazlan aldosari on 05/06/1448 AH.
//

import Foundation
import UserNotifications

class Notifications {

    // Ask the user for permission to send notifications
    // granted is true if the user allows notifications
    // error tells us if something went wrong
    func requestPermission(for plant: Plant) {

        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in

                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                    return
                }

                if granted {
                    print("Notification permission granted")

                    // Schedule the reminder after permission is granted
                    self.scheduleCreationTimeNotification(for: plant)

                } else {
                    print("Notification permission denied")
                }
            }
    }


    // Create the notification message
    func createNotificationContent() -> UNMutableNotificationContent {

        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default
        return content
    }


    // Schedule a notification for one plant
    func scheduleNotification(
        for plant: Plant,
        trigger: UNNotificationTrigger
    ) {

        // Create a notification request using the plant's ID
        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: createNotificationContent(),
            trigger: trigger
        )

        // Ask iOS to schedule the notification
        UNUserNotificationCenter.current().add(request) { error in

            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(plant.name)")
            }
        }
    }


    // Cancel a plant's pending notification
    func cancelNotification(for plant: Plant) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [plant.id.uuidString]
            )

        // Print a message after requesting cancellation to check if the notification was cancelled
        print("Notification cancelled for \(plant.name)")
    }


    // Notification based on creation time
    // Repeat the notification every selected number of days
    func scheduleCreationTimeNotification(for plant: Plant) {

        // Convert the watering frequency from days to seconds
         let seconds = TimeInterval(
             max(1, plant.wateringFrequency) * 24 * 60 * 60
         )

        // Testing reminders notifications
       // let seconds: TimeInterval = 60

        // Create a repeating notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: seconds,
            repeats: true
        )

        // Schedule the notification for this plant
        scheduleNotification(
            for: plant,
            trigger: trigger
        )
    }


    // Check which notifications are still scheduled
    // I use this to make sure each plant has its own reminder
    func checkPendingNotifications() {

        // Get the notifications waiting to be delivered
        UNUserNotificationCenter.current()
            .getPendingNotificationRequests { requests in

                print("Pending notifications: \(requests.count)")

                for request in requests {

                    // Show the ID of each notification
                    print("Notification ID: \(request.identifier)")

                    // Show how often the notification repeats
                    if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {

                        let days = trigger.timeInterval / (24 * 60 * 60)

                        print("Repeats every: \(days) days")
                    }
                }
            }
    }
}
