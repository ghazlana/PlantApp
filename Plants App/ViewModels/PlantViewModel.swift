
//
//  PlantViewModel.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//

import Foundation
import SwiftUI

// Manages the plant data and actions
@Observable
class PlantViewModel {

    // Stores all the plants added by the user
    var plants: [Plant] = []
    
    // Manage plant notifications
    private let notifications = Notifications()

    // Load my saved plants when the app starts
        init() {
            loadPlants()

            // Check if any watering cycles passed while the app was closed
            resetWateringIfNeeded()
        }

    // Adds a new plant to the list
    func addPlant(_ plant: Plant) {

        // Original code: added the plant before setting its reset date
        // plants.append(plant)

        // Make a copy so I can set the reset date before adding the plant
        var newPlant = plant
        

        // Option 2 uses elapsed 24-hour days, starting when the plant is saved.
        let interval = TimeInterval(max(1, plant.wateringFrequency)) * 24 * 60 * 60 // Convert days into seconds for addingTimeInterval()

        // Calculate when the plant's next watering cycle begins
        newPlant.nextWateringReset = plant.wateringTime.addingTimeInterval(interval)
        

        // Add the plant after setting its reset date
        plants.append(newPlant)

        // Save the updated plants so they are not lost
            savePlants()
        
        // Request permission and schedule the new plant's reminder
        notifications.requestPermission(for: newPlant)

    }

    // Updates an existing plant using its unique ID
    func updatePlant(_ updatedPlant: Plant) {

        // Get the current time to check and calculate watering deadlines
        let now = Date()

        // Reset any overdue watering cycles before saving the edited plant
        resetWateringIfNeeded(at: now)

        // Find the plant with the matching ID
        if let index = plants.firstIndex(where: {
            $0.id == updatedPlant.id
        }) {


            // Keep live watering state if a cycle changed while the form was open.
            var plantToSave = updatedPlant

            // Use the latest checkbox state, not the old state from the edit form
            plantToSave.isWatered = plants[index].isWatered

            // Keep the current reset date when editing unrelated information
            plantToSave.nextWateringReset = plants[index].nextWateringReset
            
            if plants[index].wateringFrequency != updatedPlant.wateringFrequency {

                // Convert the new watering frequency into seconds
                let interval = TimeInterval(max(1, updatedPlant.wateringFrequency)) * 24 * 60 * 60

                // Start a new watering cycle from the time of this edit
                plantToSave.nextWateringReset = now.addingTimeInterval(interval)
                
                // Update the reminder when the watering frequency changes
                notifications.scheduleCreationTimeNotification(for: plantToSave)
            }
            
            // Save the updated plant in its original position
            plants[index] = plantToSave

        }

            savePlants()

    }

    // Changes the watering status of a specific plant
    func toggleWatered(for plant: Plant) {

        // Make sure the plant is in the correct watering cycle before toggling
        resetWateringIfNeeded()

        // Find the plant using its unique ID
        if let index = plants.firstIndex(where: {
            $0.id == plant.id
        }) {

            // Switch between watered and not watered
            plants[index].isWatered.toggle()

        }

        // Save the updated plants so they are not lost
            savePlants()

    }

    // Refresh only expired cycles, rather than unchecking plants on every launch.
    func resetWateringIfNeeded(at now: Date = Date()) { //at now is a parameter representing the time to check.

        // to know if anything changed so we don't save unnecessarily
        var hasChanges = false

        // Check each plant in the array
        for index in plants.indices {

            // Convert this plant's watering frequency into seconds
            let interval = TimeInterval(max(1, plants[index].wateringFrequency)) * 24 * 60 * 60

            // Check whether this plant already has a reset date
            if let nextReset = plants[index].nextWateringReset {

                guard now >= nextReset else { //If the deadline hasn't arrived, continue skips this plant.
                    continue
                }
                
                // Skip missed cycles while keeping the original interval boundaries.


                // Find how many seconds have passed since the reset deadline
                let secondsPassed = now.timeIntervalSince(nextReset)

                // Calculate how many cycles to move forward
                // floor() rounds down, and +1 moves to the next future cycle
                let elapsedCycles = floor(secondsPassed / interval) + 1

                plants[index].isWatered = false //uncheck the plant

                // Move the reset date forward to the next future watering cycle
                plants[index].nextWateringReset = nextReset.addingTimeInterval(elapsedCycles * interval)

                hasChanges = true

            }
        }

        // Only save if a watering deadline or checkbox state changed
        if hasChanges {
            savePlants()
        }

    }
    


    // Counts how many plants have been watered
    var wateredCount: Int {

        plants.filter { $0.isWatered }.count

    }

    // Calculates watering progress between 0.0 and 1.0
    var wateringProgress: Double {

        // Avoid dividing by zero
        guard !plants.isEmpty else {
            return 0.0
        }

        return Double(wateredCount) / Double(plants.count)

    }

    // Returns a message based on watering progress
    var progressMessage: String {

        // No plants have been watered
        if wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        }

        // All plants have been watered
        else if wateredCount == plants.count {
            return "All reminders completed! 🎉"
        }

        // Some plants have been watered
        else {
            return "\(wateredCount) of your plants felt loved today ✨"
        }

    }

    func deletePlant(_ plant: Plant) {
        
        // Cancel the reminder before deleting the plant
        notifications.cancelNotification(for: plant)

        plants.removeAll { currentPlant in
            currentPlant.id == plant.id
        }

        savePlants()

    }


    // Save my plants so they don't disappear when I close the app
    func savePlants() {

        // Convert the plants array into data that can be stored
        if let data = try? JSONEncoder().encode(plants) {

            // Save the data on the iPhone using the key "savedPlants"
            UserDefaults.standard.set(data, forKey: "savedPlants")

        }

    }

    // Load my saved plants when I open the app again
    func loadPlants() {

        // Find the data saved using the key "savedPlants"
        if let data = UserDefaults.standard.data(forKey: "savedPlants") {

            // Convert the saved data back into my plants array
            if let savedPlants = try? JSONDecoder().decode([Plant].self, from: data) {

                plants = savedPlants

            }

        }

    }

}
