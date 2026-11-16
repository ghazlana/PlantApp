//
//  Plant.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//


import Foundation

// Stores the information for one plant
struct Plant: Identifiable {

    // Gives every plant a unique ID
    let id = UUID()

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
}
