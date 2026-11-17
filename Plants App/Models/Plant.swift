//
//  Plant.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//


import Foundation

// Stores the information for one plant
// Codable allows me to save my plant data and load it again when I reopen the app.

struct Plant: Identifiable, Codable {

    // Each plant gets a unique ID that can also be restored when loading saved plants
    var id = UUID()

    // Basic plant information
    var name: String
    var room: String
    var light: String
    var water: String

    // Watering reminder information
    var wateringFrequency: Int
    var wateringTime: Date

    // Tracks whether the plant has been watered
    var isWatered: Bool = false

    // Optional so plants saved before automatic resets can still be loaded.
    var nextWateringReset: Date? = nil
    
}

