
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
    func requestPermission() {

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
                } else {
                    print("Notification permission denied")
                }
            }
    }


    // Schedule a test notification after 10 seconds
   /* func scheduleTestNotification() {

        // Create the notification message
        let content = UNMutableNotificationContent()

        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        // Set the notification to appear after 10 seconds
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10,
            repeats: false
        )

        // Create the notification request
        let request = UNNotificationRequest(
            identifier: "testNotification",
            content: content,
            trigger: trigger
        )

        // Ask iOS to schedule the notification
        UNUserNotificationCenter.current().add(request) { error in

            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled")
            }
        }
    }*/


    // Create the notification message
    // Both options use the same message
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
        // Check if the notification was cancelled
        print("Notification cancelled for \(plant.name)")
    }


    // OPTION 1: Fixed notification time at 8 AM
    // This option is not active until I ask my mentor

    /*
    // Schedule reminders at 8 AM on watering days
    func scheduleFixedTimeNotification(for plant: Plant) {

        let calendar = Calendar.current

        // Make sure the watering frequency is at least one day
        let frequency = max(1, plant.wateringFrequency)

        // Remove the old reminders
        cancelNotification(for: plant)

        // Schedule the next 20 watering reminders
        for number in 1...20 {

            // Calculate the watering date
            let days = frequency * number

            guard let wateringDate = calendar.date(
                byAdding: .day,
                value: days,
                to: plant.wateringTime
            ) else {
                continue
            }

            // Get the date without the time
            var components = calendar.dateComponents(
                [.year, .month, .day],
                from: wateringDate
            )

            // Set the notification time to 8 AM
            components.hour = 8
            components.minute = 0

            // Skip dates that have already passed
            guard let date = calendar.date(from: components),
                  date > Date() else {
                continue
            }

            // Create the notification trigger
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )

            // Give each reminder a unique identifier
            let identifier = "\(plant.id.uuidString)-\(number)"

            // Create the notification request
            let request = UNNotificationRequest(
                identifier: identifier,
                content: createNotificationContent(),
                trigger: trigger
            )

            // Schedule the notification
            UNUserNotificationCenter.current().add(request) { error in

                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                }
            }
        }
    }
    */


    // OPTION 2: Notification based on creation time
    // This is the option I am currently using

    // Repeat the notification every selected number of days
    func scheduleCreationTimeNotification(for plant: Plant) {

        // Convert the watering frequency from days to seconds
        let seconds = TimeInterval(
            max(1, plant.wateringFrequency) * 24 * 60 * 60
        )

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
