//
//  PlantListView.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//

import Foundation
import SwiftUI

struct PlantListView: View {

    // The plants received from ContentView
    var plants: [Plant]

    // Action for opening the reminder form
    var onAddReminder: () -> Void

    // Action for changing a plant's watering status
    var onToggleWatered: (Plant) -> Void

    // Tells ContentView which plant was tapped
    var onEditPlant: (Plant) -> Void
    
    // Tells ContentView which plant should be deleted
    var onDeletePlant: (Plant) -> Void

    var wateringProgress: Double
    
    var progressMessage: String
    
    // Keeps track of which plant has been swiped
    @State private var swipedPlantID: UUID? = nil
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(spacing: 10){
                    // Message above the progress bar
                    Text(progressMessage)
                    //.font(.caption)
                        .font(.system(size: 14))
                        //.foregroundStyle(.white)
                    
                    // Displays watering progress
                    ProgressView(value: wateringProgress)
                        .tint(
                            Color(
                                red: 51.0 / 255,
                                green: 128.0 / 255,
                                blue: 105.0 / 255
                            )
                        )
                        .padding(.horizontal, 25)
                }
                .padding(.top, 25)
                .padding(.bottom, 30)
        
       // List {
            
            // Display each saved plant
        ForEach(plants) { plant in
            ZStack(alignment: .trailing) {
                
                // Delete button behind the plant row
                Button {
                    onDeletePlant(plant)
                    swipedPlantID = nil
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                         .foregroundStyle(.white)
                         .frame(width: 60, height: 50)
                         .background(Color(red: 1.0, green: 0.27, blue: 0.30))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                
                VStack(spacing: 10) {
                    
                    HStack(spacing: 12) {
                        
                        
                        
                        // Checkbox button
                        Button {
                            onToggleWatered(plant)
                        } label: {
                            
                            Image(
                                systemName: plant.isWatered
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .foregroundStyle(
                                plant.isWatered ? .green : .gray
                            )
                            .font(.system(size: 22))
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            // Tell ContentView which plant was selected
                            onEditPlant(plant)
                            
                        } label: {
                            // Plant information
                            VStack(alignment: .leading, spacing: 5) {
                                
                                // Room
                                HStack {
                                    Image(systemName: "location")
                                        .foregroundStyle(.gray)
                                    
                                    Text("in " + plant.room)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                // Plant name
                                Text(plant.name)
                                    .font(.system(size: 30))
                                    .fontWeight(.medium)
                                    //.foregroundStyle(.white)
                                
                                // Light and water information
                                HStack {
                                    
                                    Image(systemName: "sun.max")
                                        .foregroundStyle(
                                            Color(
                                                red: 204 / 255,
                                                green: 199 / 255,
                                                blue: 133 / 255
                                            )
                                        )
                                    
                                    Text(plant.light)
                                        .font(.caption)
                                        .foregroundStyle(
                                            Color(
                                                red: 204 / 255,
                                                green: 199 / 255,
                                                blue: 133 / 255
                                            )
                                        )
                                    
                                    Image(systemName: "drop")
                                        .foregroundStyle(
                                            Color(
                                                red: 202 / 255,
                                                green: 243 / 255,
                                                blue: 251 / 255
                                            )
                                        )
                                    
                                    Text(plant.water)
                                        .font(.caption)
                                        .foregroundStyle(
                                            Color(
                                                red: 202 / 255,
                                                green: 243 / 255,
                                                blue: 251 / 255
                                            )
                                        )
                                }
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25)
                            .contentShape(Rectangle())
                        }.buttonStyle(.plain)
                    }
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                }
                .frame(maxWidth: .infinity)
                //.background(Color.black)
                // Use an adaptive background to hide the trash button until I swipe
                                .background(Color(uiColor: .systemBackground))
                .offset(x: swipedPlantID == plant.id ? -80 : 0)
                //highPriorityGesture to give the drag gesture priority over the row's normal interactions.
                .highPriorityGesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width < -50 {
                                swipedPlantID = plant.id
                            } else if value.translation.width > 50 {
                                swipedPlantID = nil
                            }
                        }
                )
                .animation(.easeInOut(duration: 0.2), value: swipedPlantID)
            }
            /* .swipeActions(edge: .trailing, allowsFullSwipe: false) {
             Button(role: .destructive) {
             onDeletePlant(plant)
             } label: {
             Label("Delete", systemImage: "trash")
             }
             }
             .listRowBackground(Color.black)
             .listRowSeparator(.hidden)
             .listRowInsets(EdgeInsets())
             }
             }*/
        }
            
            // Pushes the plant list toward the top
            //Spacer()
            
            /*.listStyle(.plain)
             .scrollContentBackground(.hidden)
             .background(Color.black)*/
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing){

            // Add another plant
            Button {
                onAddReminder()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(
                        Color(
                            red: 51.0 / 255,
                            green: 128.0 / 255,
                            blue: 105.0 / 255
                        )
                    )
                    .clipShape(Circle())
            }
            .padding(25)
        }
    }
}
