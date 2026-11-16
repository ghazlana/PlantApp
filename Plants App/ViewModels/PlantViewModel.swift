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

    // Adds a new plant to the list
    func addPlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    // Updates an existing plant using its unique ID
    func updatePlant(_ updatedPlant: Plant) {

        // Find the plant with the matching ID
        if let index = plants.firstIndex(where: {
            $0.id == updatedPlant.id
        }) {

            // Replace the old plant with the updated plant
            plants[index] = updatedPlant
        }
    }
    
    // Changes the watering status of a specific plant
    func toggleWatered(for plant: Plant) {

        // Find the plant using its unique ID
        if let index = plants.firstIndex(where: {
            $0.id == plant.id
        }) {

            // Switch between watered and not watered
            plants[index].isWatered.toggle()
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
        plants.removeAll { currentPlant in
            currentPlant.id == plant.id
        }
    }
}
