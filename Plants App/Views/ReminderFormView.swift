
//
//  ReminderFormView.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//

import Foundation
import SwiftUI

struct ReminderFormView: View {

    // Temporary values entered by the user
    @State private var plantName = ""
    @State private var plantRoom = "Bedroom"
    @State private var plantWater = "20-50 ml"
    @State private var wateringFrequency = 3
    @State private var plantLight = "Full sun"
    @State private var wateringTime = Date()

    
    

    // Actions received from ContentView
    var editingPlant: Plant? = nil    // The plant being edited, or nil when adding
    var onSave: (Plant) -> Void
    var onCancel: () -> Void
    var onDelete: (Plant) -> Void

    
    // @escaping lets me store these actions and call them later
    init(
        editingPlant: Plant? = nil,
        onSave: @escaping (Plant) -> Void,
        onCancel: @escaping () -> Void,
        onDelete: @escaping (Plant) -> Void = { _ in }// { _ in } is a default empty action because new plants don't need Delete
    ) {
        // Store the received plant and actions
        self.editingPlant = editingPlant
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete

        // Fill the fields using existing data or defaults
        _plantName = State(initialValue: editingPlant?.name ?? "")
        _plantRoom = State(initialValue: editingPlant?.room ?? "Bedroom")
        _plantLight = State(initialValue: editingPlant?.light ?? "Full sun")
        _plantWater = State(initialValue: editingPlant?.water ?? "20-50 ml")
        _wateringFrequency = State(initialValue: editingPlant?.wateringFrequency ?? 3)
        _wateringTime = State(initialValue: editingPlant?.wateringTime ?? Date())
    }

    var body: some View {

        //form
        // .sheet(isPresented: $reminderForm){

        VStack(alignment: .leading, spacing: 20) {

            HStack {

                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }

                Spacer()

                Text(editingPlant == nil ? "Set Reminder" : "Edit Reminder")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                // Save button
                Button {

                    var plant = editingPlant ?? Plant(
                        name: plantName,
                        room: plantRoom,
                        light: plantLight,
                        water: plantWater,
                        wateringFrequency: wateringFrequency,
                        wateringTime: wateringTime
                    )

                    //viewModel.addPlant(newPlant)
                    // reminderForm = false

                    // Update the plant's information
                    plant.name = plantName
                    plant.room = plantRoom
                    plant.light = plantLight
                    plant.water = plantWater
                    plant.wateringFrequency = wateringFrequency
                    //plant.wateringTime = wateringTime
                    // For a new plant, save the time when the user taps Save.
                    // When editing, keep the original time so the watering schedule doesn't change.
                    if editingPlant == nil {
                        plant.wateringTime = Date()
                    }
                    onSave(plant)

                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Color(
                                red: 51.0 / 255,
                                green: 128.0 / 255,
                                blue: 105.0 / 255
                            )
                        )
                        .clipShape(Circle())
                }
                .disabled(plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            }
            .padding(.top, 20)
            .padding(.horizontal, 7)

            //Space between text and text field
            VStack(alignment: .leading, spacing: 45) {

                // PlantTextField(title: "Plant Name", text: $plantName)

                HStack(spacing: 8) {

                    Text("Plant Name")
                       // .foregroundStyle(.white)

                    TextField("Pothos", text: $plantName)
                       // .foregroundStyle(.white)
                }
                .padding(16)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())

                VStack(spacing: 0) {

                    HStack {

                        Image(systemName: "location")
                          //  .foregroundStyle(.white)

                        Text("Room")
                           // .foregroundStyle(.white)

                        Spacer()

                        Picker("Plant Room", selection: $plantRoom) {

                            Text("Bedroom").tag("Bedroom")
                            Text("Living Room").tag("Living Room")
                            Text("Kitchen").tag("Kitchen")
                            Text("Bathroom").tag("Bathroom")
                            Text("Balcony").tag("Balcony")
                        }
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                        .labelsHidden()
                    }
                    .padding(8)

                    Divider()
                        .background(Color.gray)

                    // Light
                    HStack {

                        Image(systemName: "sun.max")
                            //.foregroundStyle(.white)

                        Text("Light")
                            //.foregroundStyle(.white)

                        Spacer()

                        Picker("Plant Light", selection: $plantLight) {

                            Text("Full Sun").tag("Full sun")
                            Text("Partial Sun").tag("Partial Sun")
                            Text("Low Light").tag("Low Light")
                        }
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                        .labelsHidden()
                    }
                    .padding(8)
                }
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 30))

                VStack(spacing: 0) {

                    HStack {

                        Image(systemName: "drop")
                            //.foregroundStyle(.white)

                        Text("Watering Days")
                            //.foregroundStyle(.white)

                        Spacer()

                        Picker("Watering Frequency", selection: $wateringFrequency) {

                            Text("Every day").tag(1)
                            Text("Every 2 days").tag(2)
                            Text("Every 3 days").tag(3)
                            Text("Once a week").tag(7)
                            Text("Every 10 days").tag(10)
                            Text("Every 2 weeks").tag(14)
                        }
                        .pickerStyle(.menu)
                        .tint(.gray)
                        .labelsHidden()
                    }
                    .padding(8)

                    Divider()
                        .background(Color.gray)

                    HStack {

                        Image(systemName: "drop")
                          //  .foregroundStyle(.white)

                        Text("Water")
                            //.foregroundStyle()

                        Spacer()

                        Picker("Plant water", selection: $plantWater) {

                            Text("20-50 ml").tag("20-50 ml")
                            Text("50-100 ml").tag("50-100 ml")
                            Text("100-200 ml").tag("100-200 ml")
                            Text("200-300 ml").tag("200-300 ml")
                        }
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                        .labelsHidden()
                    }
                    .padding(8)
                }
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 30))


                //Spacer()

                // Only show Delete when editing an existing plant
                if let editingPlant = editingPlant {

                    Button {
                        onDelete(editingPlant)
                    } label: {

                        Text("Delete Reminder")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                    .buttonStyle(.plain)
                    .padding(.bottom, 20)
                }

            } // End of form fields VStack

            Spacer() // Keeps remaining space below the form

        } // End of main VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       // .background(Color(red: 0.10, green: 0.10, blue: 0.10))
        //.preferredColorScheme(.dark)

        // Spacer()
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)


}
